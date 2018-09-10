{-# LANGUAGE OverloadedStrings #-}

module Mensae ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import qualified Data.Tree

data Prop = NewProp T.Text | Apply T.Text Prop deriving (Eq, Show)

selectProp :: 

page :: MonadWidget t m => m (Event t T.Text)
page = do
  h2t = elAttr "h2" . text
  h2t "> :: Prop → nat"
  h2t "< :: nat -> Prop"
  h2t "Proof n m := m is proof for <n"
  h2t "Provable n := exists m. Proof n m"