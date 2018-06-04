{-# LANGUAGE OverloadedStrings #-}

module Error404 ( page ) where

import Reflex.Dom

page :: MonadWidget t m => m (Event String)
page = return never