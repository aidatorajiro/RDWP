{-# LANGUAGE OverloadedStrings #-}

module Mn1 ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements

page :: MonadWidget t m => m (Event t T.Text)
page = do
    el "style" $ text "body{background:#2f1371;}"
    let stl = "cursor: pointer; background: #efb5db;"
    let btn = fmap (domEvent Click . fst) . elStyle' "div" stl . text 
    btnLeft <- btn "←"
    btnUp <- btn "↑"
    btnDown <- btn "↓"
    btnRight <- btn "→"
    
