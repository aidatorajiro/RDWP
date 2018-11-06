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
      ln "/ars" Ars.page
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
#ifdef ghcjs_HOST_OS
  initLoc <- Right <$> getLocationPath

  -- "Left" locations will be pushed to the browser state , while "Right" locations won't be.
  ee <- dyn $ (either (\l -> pushState l >> router l) router) <$> loc

  -- Using some magic to flatten an Event of Event.
  be <- hold never ee

  -- Get the broeser's popState Event
  browserEv <- popState

  -- Define the location :: Either (Event Text) (Event Text), then back to the loop.
  loc <- holdDyn initLoc (leftmost [Left <$> switch be, Right <$> browserEv])
#else
  ee <- dyn $ router <$> loc
  be <- hold never ee
  loc <- holdDyn "/" (switch be)
#endif
  return ()
