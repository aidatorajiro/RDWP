{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event t String)
page = return never