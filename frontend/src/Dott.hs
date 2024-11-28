{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE TemplateHaskell #-}

module Dott ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ
import Data.Char (ord)
import qualified Data.Map as M
import Data.FileEmbed (embedStringFile, makeRelativeToProject)
import Control.Monad(when, void)

css :: T.Text
css = [r|
body {
    background: #9b13f7;
}
|]

page :: MonadWidget t m => String -> m (Event t T.Text)
page s = do
    style css
    return never

-- log ga bakete detekuru
dott :: T.Text
dott = T.pack $(makeRelativeToProject "dot.txt" >>= embedStringFile)
