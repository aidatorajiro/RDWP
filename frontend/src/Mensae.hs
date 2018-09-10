{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}

module Mensae ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import qualified Data.Tree
import Data.Monoid ((<>))

data Prop = NewProp T.Text | Apply T.Text Prop deriving (Eq, Show)

selectProp :: MonadWidget t m => Prop -> m (Dynamic t Prop)
selectProp p@(NewProp t) = el "span" (text t) >> return (constDyn p)
selectProp a@(Apply t p) = mdo
  (outerEl, innerDyn) <- elDynAttr' "span" (M.singleton "style" <$> color) $ do
    text t
    text "("
    d <- selectProp p
    text ")"
    return d
  let outerEv = domEvent Click outerEl
  let innerEv = updated innerDyn
  color <- holdDyn "background-color: #CCCCCC;" $ leftmost ["background-color: #FFFFFF;" <$ innerEv, "background-color: #CCCCCC;" <$ outerEv]
  holdDyn a $ leftmost [p <$ innerEv, a <$ outerEv]

page :: MonadWidget t m => m (Event t T.Text)
page = do
  let h2t = el "h2" . text
  h2t "toNat :: Prop → nat"
  h2t "toProp :: nat → Prop"
  h2t "Proof n m := m is proof for (toNat n)"
  h2t "Provable n := exists m. Proof n m"
  p <- elAttr "p" (M.singleton "style" "font-size: 42px;") $ selectProp $ Apply "toNat" $ Apply "Provable" $ NewProp "P"
  display p
  return never
