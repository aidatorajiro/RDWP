{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom
import qualified Data.Text as T

page :: MonadWidget t m => m (Event t T.Text)
page = return never
