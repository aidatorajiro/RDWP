{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts #-}

module LibMain ( startApp ) where

import Control.Applicative

import GHCJS.DOM ( currentWindowUnchecked )
import GHCJS.DOM.EventM ( on )
import GHCJS.DOM.Window ( getHistory )
import qualified GHCJS.DOM.History as History
import qualified GHCJS.DOM.WindowEventHandlers as WindowEventHandlers
import Reflex.Dom
import Reflex.Dom.Location ( getLocationPath )
import qualified Data.Text as T

import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404
import qualified Nami
import qualified Nazo
import qualified Mn1

router :: MonadWidget t m => T.Text -> m ( Event t T.Text )
router s = case s of
  "/index" -> Index.page
  "/" -> FakeIndex.page
  "/mensae" -> Mensae.page
  "/nmnmnmnmn" -> Nami.page
  "/nazo" -> Nazo.page
  "/worry" -> Mn1.page
  otherwise -> Error404.page

pushState :: MonadWidget t m => T.Text -> m ()
pushState l = do
  history <- getHistory =<< currentWindowUnchecked
  History.pushState history (0 :: Double) ("" :: T.Text) (Just l :: Maybe T.Text)

popState :: MonadWidget t m => m (Event t T.Text)
popState = do
  window <- currentWindowUnchecked
  wrapDomEventMaybe window (`on` WindowEventHandlers.popState) (Just <$> getLocationPath)

startApp :: IO ()
startApp = do
  init_loc <- getLocationPath
  mainWidget $ mdo
    ee <- dyn $
          (\l -> pushState l >> liftA2 mappend (router l) popState) <$>
          loc
    be <- hold never ee
    loc <- holdDyn init_loc (switch be) 
    return ()
