{-# LANGUAGE OverloadedStrings #-}

module Mn1 ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event t String)
page = return never