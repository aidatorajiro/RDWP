{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts, CPP, QuasiQuotes #-}

module LibMain ( startApp ) where

import GHCJS.DOM ( currentWindowUnchecked )
import GHCJS.DOM.EventM ( on )
import GHCJS.DOM.Window ( getHistory )
import qualified GHCJS.DOM.History as History
import qualified GHCJS.DOM.WindowEventHandlers as WindowEventHandlers
import Reflex.Dom
import Reflex.Dom.Location ( getLocationPath )
import qualified Data.Text as T
import Text.Parsec

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
import Elements ( style )
import Text.RawString.QQ
import Data.Either

resetCss :: T.Text
resetCss = [r|
  /*
  html5doctor.com Reset Stylesheet
  v1.6.1
  Last Updated: 2010-09-17
  Author: Richard Clark - http://richclarkdesign.com
  Twitter: @rich_clark
  */
  
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
  
  /* change colours to suit your needs */
  ins {
      background-color:#ff9;
      color:#000;
      text-decoration:none;
  }
  
  /* change colours to suit your needs */
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
  
  /* change border colour to suit your needs */
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
    overflow: hidden;
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
      ln path widget = string path >> fmap (widget . read) (many digit)
      -- ex. "/testes_a", "/testes_ksk", "/testes_tska", ...
      ls path widget = string path >> char '_' >> fmap widget (many anyChar)
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
      l "/ubana" Ubana.page,
      l "/nannkahenndayo" Ubana.page
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
startApp = mainWidget $ mdo
  -- set reset css
  style resetCss

  -- Get an Event of Event which contains dynamically changing widget.
  ee <- dyn $ router <$> loc

  -- Using some magic to flatten an Event of Event to get a location update Event from the router.
  routerEv <- switch <$> hold never ee

#ifdef ghcjs_HOST_OS
  -- Get current value of location.path.
  initLoc <- getLocationPath

  -- Get the browser's popState Event
  browserEv <- popState

  -- Push locations from the router Event to the browser history.
  widgetHold (return ()) (pushState <$> routerEv)

  -- Define location, then back to the loop.
  loc <- holdDyn initLoc (leftmost [routerEv, browserEv])
#else
  loc <- holdDyn "/" routerEv
#endif
  return ()
