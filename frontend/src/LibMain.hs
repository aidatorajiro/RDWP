{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}

module LibMain ( startApp ) where

import Reflex.Dom
import Location
import Text.Parsec

import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404

path :: Stream s m Char => String -> IO () -> ParsecT s u m (IO ())
path x m = string x >> eof >> return m

pathParser :: Stream s m Char => ParsecT s u m (IO ())
pathParser   =   (path "index" Index.page)
            <|>  (path "" FakeIndex.page)
            <|>  (path "mensae" Mensae.page)
            <|>  (return Error404.page)

router :: String -> IO ()
router s = either (fail "url parse error") id (parse pathParser "" s)

startApp :: IO ()
startApp = router =<< location