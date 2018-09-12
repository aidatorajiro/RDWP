{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}

module Mensae ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import qualified Data.Tree
import Data.Monoid ((<>))
import Elements

data Func = NewFunc T.Text | Apply T.Text Func deriving (Eq, Show)

{-
selectFunc :: MonadWidget t m => Func -> m (Dynamic t Func)
selectFunc p@(NewFunc t) = do
  (span, _) <- el' "span" $ text t
  holdDyn p (p <$ domEvent Click span)

selectFunc a@(Apply t p) = mdo
  (outerEl, innerEv) <- elDynStyle' "span" $ do
    text t
    updated <$> selectFunc p
  let outerEv = domEvent Click outerEl
  styleDyn <- holdDyn "background: #CCC;" $ leftmost ["background: transparent;" <$ innerEv, "background: #CCC;" <$ outerEv]
  holdDyn a $ leftmost [innerEv, a <$ outerEv]
-}

page :: MonadWidget t m => m (Event t T.Text)
page = do
  let h2t = el "h2" . text
  h2t "toNat :: Prop → nat"
  h2t "toProp :: nat → Prop"
  h2t "Proof n m := m is proof for (toProp n)"
  h2t "Provable n := exists m. Proof n m"
  --p <- elStyle "p" "font-size: 42px;" $ selectFunc $ Apply "toNat" $ Apply "Provable" $ Apply "toNat" $ NewFunc "P"
  --display p
  return never
