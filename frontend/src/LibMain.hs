{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts, CPP #-}

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
import qualified ArsGame
import qualified IClub

-- | parse URL Location Path
parseLocationPath :: MonadWidget t m => Parsec T.Text () (m (Event t T.Text))
parseLocationPath =
  let l path widget = string path >> eof >> return widget
      ln path widget = string path >> fmap (widget . read) (many digit)
  in choice $ map try [
      l "/index" Index.page,
      l "/" FakeIndex.page,
      l "" FakeIndex.page,
      l "/mensae" Mensae.page,
      l "/nmnmnmnmn" Nami.page,
      l "/nazo" Nazo.page,
      l "/worry" Mn1.page,
      l "/ars_g" ArsGame.page,
      ln "/ars" Ars.page,
      l "/iclub" IClub.page
    ]

-- | route location paths to dom widgets
router :: MonadWidget t m => T.Text -> m ( Event t T.Text )
router s = either (const Error404.page) id (parse parseLocationPath "LocationPath" s)

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
