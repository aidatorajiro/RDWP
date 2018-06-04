{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event String)
page = return never