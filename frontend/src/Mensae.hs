{-# LANGUAGE OverloadedStrings #-}

module Mensae ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import qualified Data.Tree
import qualified Data.Monoid ((<>))

data Prop = NewProp T.Text | Apply T.Text Prop deriving (Eq, Show)

select :: MonadWidget t m => Prop -> m (Dynamic t Prop)
select (NewProp t) = el "span" (text t) >> constDyn (NewProp t)
select (Apply t p)@a = mdo
  (outer, (inner, _)) <- elDynAttr' "span" (M.singleton "background-color" <$> color) $ do
    text t
    el' "small" (select p)
  holdDyn a ((p <$ innerEv) <> (a <$ outerEv))
  color <- holdDyn "#FFFFFF" (("#FFFFFF" <$ innerEv) <> ("#CCCCCC" <$ outerEv))

page :: MonadWidget t m => m (Event t T.Text)
page = do
  h2t = el "h2" . text
  h2t "toNat :: Prop → nat"
  h2t "toProp :: nat → Prop"
  h2t "proof n m := m is proof for <n"
  h2t "provable n := exists m. Proof n m"
  select $ Apply "toNat" $ Apply "Provable" $ NewProp "P"