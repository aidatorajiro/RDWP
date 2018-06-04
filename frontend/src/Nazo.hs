{-# LANGUAGE OverloadedStrings #-}

module Nazo ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event String)
page = return never