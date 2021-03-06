{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Mn2 ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ

css :: T.Text
css = [r|
body {
    background: #13712f;
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    return never
