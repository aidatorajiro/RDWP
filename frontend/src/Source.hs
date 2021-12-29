{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Source (page) where

-- Source.hs, a.k.a. code forest, a.k.a. /cf1*
-- neta: cf1 ... bitcoin address ...

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Text.RawString.QQ

page :: MonadWidget t m => String -> m (Event t T.Text)
page s = do
    style [r|
body {
    background: #120317;
}
|]
    return never