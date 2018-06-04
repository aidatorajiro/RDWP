{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}

module LibMain ( startApp ) where

import Reflex.Dom
import Location
import Text.Parsec
import Reflex.Dom.Location ( getLocationPath )

import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404
import qualified Nami
import qualified Nazo
import qualified Mn1

router :: MonadWidget t m => String -> m ( Event t String )
router s = case s of
  "index" -> Index.page
  "" -> FakeIndex.page
  "mensae" -> Mensae.page
  "nmnmnmnmn" -> Nami.page
  "nazo" -> Nazo.page
  "worry" -> Mn1.page
  otherwise -> Error404.page

startApp :: IO ()
startApp = do
  init_loc <- getLocationPath
  mainWidget $ mdo
    ev <- coincidence =<< dyn ((pushState >=> router) <$> loc)
    loc <- holdDyn init_loc ev
    return ()