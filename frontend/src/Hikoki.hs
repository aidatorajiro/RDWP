{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Hikoki ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

page :: MonadWidget t m => [Char] -> m (Event t T.Text)
page headline = do
    style [r|
.hikoki {width: 100%; height: 100%;}
|]
    h1 (T.pack headline)
    assetImgClass "hikoki.jpg" "hikoki" (return ())
    return never
