{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Error404 ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

css :: T.Text
css = [r|
img {
    width: 100%;
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    assetImg "4041.png" (return ())
    return never
