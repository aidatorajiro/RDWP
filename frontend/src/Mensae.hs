{-# LANGUAGE OverloadedStrings #-}

module Mensae ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event t String)
page = return never