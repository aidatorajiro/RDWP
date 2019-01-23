{-# LANGUAGE OverloadedStrings #-}

module ArsGame where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom

page :: MonadWidget t m => m (Event t T.Text)
page = do
  style "body{background:#20273f;}"
  return never
