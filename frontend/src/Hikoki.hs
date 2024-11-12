{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Hikoki ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style [r|
.hikoki {width: 100%; height: 100%;}
|]
    assetImgClass "hikoki.jpg" "hikoki" (return ())
    return never
