{-# LANGUAGE RecursiveDo, OverloadedStrings, FlexibleContexts #-}

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

-- parse URL Location Path
parseLocationPath :: MonadWidget t m => Parsec T.Text () (m (Event t T.Text))
parseLocationPath =
  let l path widget = do
    string path
    return widget
  in choice [
    l "/index" Index.page,
    l "/" FakeIndex.page,
    l "/mensae" Mensae.page,
    l "/nmnmnmnmn" Nami.page,
    l "/nazo" Nazo.page,
    l "/worry" Mn1.page,
    l "/ars_g" ArsGame.page,
    do
      string "/ars"
      n <- many digit
      return $ Ars.page $ read n
    ]

router :: MonadWidget t m => T.Text -> m ( Event t T.Text )
router s = either (const Error404.page) id (parse parseLocationPath "LocationPath" s)

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
  initLoc <- getLocationPath
  mainWidget $ mdo
    ee <- dyn $
      (\l -> pushState l >> do
        routerEv <- router l
        browserEv <- popState
        return $ leftmost [browserEv, routerEv]
      ) <$> loc
    be <- hold never ee
    loc <- holdDyn initLoc (switch be)
    return ()
