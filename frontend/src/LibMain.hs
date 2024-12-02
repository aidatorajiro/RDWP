{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts, QuasiQuotes, CPP #-}

module LibMain ( startApp ) where


import qualified GHCJS.DOM.History as History
import qualified GHCJS.DOM.WindowEventHandlers as WindowEventHandlers
import qualified Data.Text as T
import qualified Reflex.Dom.WebSocket as WS
import qualified Error404
import qualified Control.Monad
import qualified Data.ByteString as BS
import System.Environment ( getArgs )
import GHCJS.DOM ( currentWindowUnchecked )
import GHCJS.DOM.EventM ( on )
import GHCJS.DOM.Window ( getHistory, getLocation )
import Reflex.Dom
import Reflex.Dom.Location ( getLocationPath )
import Text.Parsec ( parse )
import Safe (atMay)
import Router (parseLocationPath)
import Elements ( style )
import Text.RawString.QQ ( r )
import Data.Either ( fromRight )
import Data.Maybe (fromMaybe)
import GHC.TypeError (ErrorMessage(Text))
import System.Directory.Extra (getCurrentDirectory)
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (threadDelay)
import Util (tryActions, flatEventMaybe, widgetHoldNoop)
import Language.Javascript.JSaddle (ToJSVal(toJSVal), eval)
import JSDOM.Types (liftJSM)
import Data.Text.Encoding (decodeUtf8)
import System.Exit (exitWith, ExitCode (ExitSuccess))
import JSDOM.Generated.Location (getHostname)

resetCss :: T.Text
resetCss = [r|
  






  
  html, body, div, span, object, iframe,
  h1, h2, h3, h4, h5, h6, p, blockquote, pre,
  abbr, address, cite, code,
  del, dfn, em, img, ins, kbd, q, samp,
  small, strong, sub, sup, var,
  b, i,
  dl, dt, dd, ol, ul, li,
  fieldset, form, label, legend,
  table, caption, tbody, tfoot, thead, tr, th, td,
  article, aside, canvas, details, figcaption, figure,
  footer, header, hgroup, menu, nav, section, summary,
  time, mark, audio, video {
      margin:0;
      padding:0;
      border:0;
      outline:0;
      font-size:100%;
      vertical-align:baseline;
      background:transparent;
  }
  
  body {
      line-height:1;
  }
  
  article,aside,details,figcaption,figure,
  footer,header,hgroup,menu,nav,section {
      display:block;
  }
  
  nav ul {
      list-style:none;
  }
  
  blockquote, q {
      quotes:none;
  }
  
  blockquote:before, blockquote:after,
  q:before, q:after {
      content:'';
      content:none;
  }
  
  a {
      margin:0;
      padding:0;
      font-size:100%;
      vertical-align:baseline;
      background:transparent;
  }
  
  
  ins {
      background-color:#ff9;
      color:#000;
      text-decoration:none;
  }
  
  
  mark {
      background-color:#ff9;
      color:#000;
      font-style:italic;
      font-weight:bold;
  }
  
  del {
      text-decoration: line-through;
  }
  
  abbr[title], dfn[title] {
      border-bottom:1px dotted;
      cursor:help;
  }
  
  table {
      border-collapse:collapse;
      border-spacing:0;
  }
  
  
  hr {
      display:block;
      height:1px;
      border:0;  
      border-top:1px solid #cccccc;
      margin:1em 0;
      padding:0;
  }
  
  input, select {
      vertical-align:middle;
  }

  body {
    font-size: 18px;
  }

  h1 {
    font-size: 300%;
  }
  h2 {
    font-size: 250%;
  }
  h3 {
    font-size: 200%;
  }
  h4 {
    font-size: 150%;
  }
  h5 {
    font-size: 100%;
  }
  h6 {
    font-size: 50%;
  }
|]

-- | route location paths to dom widgets
router :: MonadWidget t m => T.Text -> m ( Event t T.Text )
router s = fromRight Error404.page (parse parseLocationPath "LocationPath" s)

-- | push browser history state
pushState :: MonadWidget t m => T.Text -> m ()
pushState l = do
  history <- getHistory =<< currentWindowUnchecked
  History.pushState history (0 :: Double) ("" :: T.Text) (Just l :: Maybe T.Text)

-- | pop browser history state into an event
popState :: MonadWidget t m => m (Event t T.Text)
popState = do
  window <- currentWindowUnchecked
  wrapDomEventMaybe window (`on` WindowEventHandlers.popState) (Just <$> getLocationPath)

-- | start the app
startApp :: IO ()
startApp = do
  args <- getArgs
  mainWidget $ mdo
    -- set reset css
    style resetCss

#ifndef ghcjs_HOST_OS
    -- try connecting to the websocket server
    ws_recv <- tryActions 1 10 $ do
      let ws_conf = WS.WebSocketConfig
                ws_in
                never
                False
                []
      lh <- getLocationHost
      ws <- WS.textWebSocket ("ws://" <> lh <> "/wsapi") ws_conf
      let ws_recv = WS._webSocket_recv ws
      let err_ev = WS._webSocket_error ws
      return (err_ev, ws_recv)
#endif

#ifndef RDWP_IS_WEBKIT
    -- For Warp / GHCJS, browser state is managed by the browser.
    -- A separate websocket server can send RELOAD command, after the source code change.
    -- Therefore initLoc             => getLocationPath
    --           browserEv           => popState
    --           widgetHold routerEv => pushState
    --           reload page         => RELOAD command from the websocket

#ifndef ghcjs_HOST_OS
    -- TODO: its too pretentious to use Event here; better brought up to the top as a process separated from mainWidget?
    let ws_in = ["never" :: T.Text] <$ never

    -- after server shutdown, every haskell code will not work, so push reload action to the most basic level of javascript engine via eval and setTimeout.
    let reload_action x = Control.Monad.when (x == "RELOAD-- NOW") $ do
                liftJSM $ eval ("setTimeout(function () { location.reload() }, 3000)" :: String)
                return ()
    
    widgetHoldNoop (reload_action <$> ws_recv)
#endif
    
    -- Get an Event of Event which contains dynamically changing widget.
    ee <- dyn $ router <$> loc

    -- Using some magic to flatten an Event of Event to get a location update Event from the router.
    routerEv <- switch <$> hold never ee

    -- Get current value of location.path.
    initLoc <- getLocationPath

    -- Get the browser's popState Event
    browserEv <- popState

    -- Push locations from the router Event to the browser history.
    widgetHoldNoop (pushState <$> routerEv)

    -- Define location, then back to the loop.
    loc <- holdDyn initLoc (leftmost [routerEv, browserEv])

    return ()
#else
    -- For Webkit GTK, browser state is managed by the websocket server (separate process).
    -- The websocket server sends MOVEPAGE command to change pages.
    -- The browser sends MOVEPAGE command to the websocket server to notify the page change as well.
    -- Also the websocket app is responsible for reloading binary. If the source code is updated, it will send SHUTDOWN command.
    --
    --
    -- Therefore, initLoc              => "",
    --            browserEv            => MOVEPAGE read from websocket
    --                       routerEv  => MOVEPAGE sent to   websocket
    --            shutdown the process => SHUTDOWN read from websocket
    --
    --

    -- Get an Event of Event which contains dynamically changing widget.
    ee <- dyn $ router <$> loc

    -- Using some magic to flatten an Event of Event to get a location update Event from the router.
    routerEv <- switch <$> hold never ee

    -- input to the websocket
    let ws_in = (\x -> ["MOVEPAGE " <> x]) <$> routerEv

    -- Get current value of location.path (default to the top page)
    initLoc <- return ""

    -- Read location change from the websocket server
    let browserEv = (\x ->
            let t = decodeUtf8 x in
              if T.take 9 t == "MOVEPAGE "
                then Just (T.drop 9 t)
                else Nothing) <$> ws_recv
    
    widgetHoldNoop ((\x -> 
        let x' = decodeUtf8 x in
        Control.Monad.when (x' == "SHUTDOWN NOW")
        (liftIO $ exitWith ExitSuccess)) <$> ws_recv)

    -- Define location, then back to the loop.
    loc <- holdDyn initLoc (leftmost [routerEv, flatEventMaybe browserEv])
    
    return ()
#endif
