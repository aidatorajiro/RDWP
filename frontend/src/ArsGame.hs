{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module ArsGame where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

css :: T.Text
css = [r|
body {
    background: #2f1371;
}
#main {
  display: grid;
  grid-template-columns: 40px auto 80px auto 40px;
  grid-template-rows: 40px 100px 100px 100px 100px 100px 100px 100px 100px 40px;
  width: 100%;
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
  style css
  return never
