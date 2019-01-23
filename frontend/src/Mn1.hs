{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Mn1 ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ

css :: T.Text
css = [r|
body {
    background: #2f1371;
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    btnLeft <- button "0"
    btnUp <- button "1"
    btnDown <- button "2"
    btnRight <- button "3"

    return never
