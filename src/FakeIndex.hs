{-# LANGUAGE OverloadedStrings #-}

module FakeIndex ( page ) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Map as M

import Reflex.Dom
import Elements (h1ID)

css :: B.ByteString
css = "\
\#heading {\
\  \
\}"

page :: IO ()
page = mainWidgetWithCss css $ h1ID "heading" "R.D.W.P."