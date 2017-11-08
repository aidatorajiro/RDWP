{-# LANGUAGE OverloadedStrings #-}

module LibMain ( startApp ) where

import Reflex.Dom
import Location

import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404

router :: String -> IO ()
router "index" = Index.page
router "" = FakeIndex.page
router "mensae" = Mensae.page
router _ = Error404.page

startApp :: IO ()
startApp = router =<< location