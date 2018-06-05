{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom
import qualified Data.Map as M
import qualified Data.Text as T
import Util ( getTickCount )
import Elements

page :: MonadWidget t m => m (Event t T.Text)
page = do
  cnt <- getTickCount
  elStyle "span" "position: fixed; top: 0px; left: 0px;" $ display cnt
  return never
  
