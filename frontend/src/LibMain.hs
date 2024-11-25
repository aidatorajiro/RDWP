{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts, QuasiQuotes, CPP #-}

module LibMain ( startApp ) where

import System.Environment
import GHCJS.DOM ( currentWindowUnchecked )
import GHCJS.DOM.EventM ( on )
import GHCJS.DOM.Window ( getHistory )
import qualified GHCJS.DOM.History as History
import qualified GHCJS.DOM.WindowEventHandlers as WindowEventHandlers
import Reflex.Dom
import Reflex.Dom.Location ( getLocationPath )
import qualified Data.Text as T
import Text.Parsec
import Safe (atMay)
import qualified Reflex.Dom.WebSocket as WS

import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404
import qualified Nami
import qualified Nazo
import qualified Mn1
import qualified Ars
import qualified IClub
import qualified Harituke
import qualified Ubana
import qualified Onsen
import qualified Logg
import qualified Source
import qualified Dott
import qualified Hikoki
import Elements ( style )
import Text.RawString.QQ
import Data.Either
import Data.Maybe (fromMaybe)
import GHC.TypeError (ErrorMessage(Text))
import System.Directory.Extra (getCurrentDirectory)
import Control.Monad.IO.Class (liftIO)
import qualified Control.Monad
import Control.Concurrent (threadDelay)
import Util (tryActions, flatEventMaybe, widgetHoldNoop)
import qualified JSDOM.Generated.Location as GHCJS.DOM
import Language.Javascript.JSaddle (ToJSVal(toJSVal))
import JSDOM.Types (liftJSM)
import qualified Data.ByteString as BS
import Data.Text.Encoding (decodeUtf8)
import System.Exit (exitWith, ExitCode (ExitSuccess))

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

-- | parse URL Location Path
parseLocationPath :: MonadWidget t m => Parsec T.Text () (m (Event t T.Text))
parseLocationPath =
  let -- ex. "/testes"
      l path widget = string path >> eof >> return widget
      -- ex. "/testes0", "/testes1", "/testes2", ...
      ln path widget = string path >> fmap (widget . read) (many1 digit)
      -- ex. "/testes_a", "/testes_ksk", "/testes_tska", ...
      ls path widget = string path >> fmap widget (many anyChar)
  in choice $ map try [
      l "/index" Index.page,
      l "/" FakeIndex.page,
      l "" FakeIndex.page,
      l "/mensae" Mensae.page,
      l "/nmnmnmnmn" Nami.page,
      l "/nazo" Nazo.page,
      l "/worry" Mn1.page,
      l "/skate" Mn1.page,
      ln "/ars" Ars.page,
      ln "/onsen" Onsen.page,
      l "/iclub" IClub.page,
      l "/harituke" Harituke.page,
      l "/nannkahenndayo" Ubana.page,
      l "/logg" Logg.page,
      ls "/cf1" Source.page,
      ls "/dott" Dott.page,
      Hikoki.page <$> many anyChar
    ]

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

    -- try connecting to the websocket server
    ws_recv <- tryActions 1 10 $ do
      let ws_conf = WS.WebSocketConfig
                ws_in
                never
                False
                []
      ws <- WS.webSocket "ws://localhost:11923/wsapi" ws_conf
      let ws_recv = WS._webSocket_recv ws
      let err_ev = WS._webSocket_error ws
      return (err_ev, ws_recv)

#ifndef RDWP_IS_WEBKIT
    -- For Warp / GHCJS, browser state is managed by the browser.
    -- A separate websocket server can send RELOAD command, after the source code change.
    -- Therefore initLoc             => getLocationPath
    --           browserEv           => popState
    --           widgetHold routerEv => pushState
    --           reload page         => RELOAD command from the websocket

    let ws_in = ["never" :: T.Text] <$ never

    let reload_action x = Control.Monad.when (x == "RELOAD") $ do
                -- v <- liftJSM . toJSVal =<< getLocationPath
                v <- liftJSM . toJSVal =<< sample (current loc)
                GHCJS.DOM.reload (GHCJS.DOM.Location v)
    
    widgetHoldNoop (reload_action <$> ws_recv)

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
        Control.Monad.when (x' == "SHUTDOWN")
        (liftIO $ exitWith ExitSuccess)) <$> ws_recv)

    -- Define location, then back to the loop.
    loc <- holdDyn initLoc (leftmost [routerEv, flatEventMaybe browserEv])
    
    return ()
#endif