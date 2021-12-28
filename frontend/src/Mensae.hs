{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Mensae ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ
import Data.Tree
import Data.Monoid ((<>))
import Elements

selectTree :: MonadWidget t m => Tree T.Text -> m (Event t T.Text)
selectTree = foldr (\txt mev -> do
    (e, _) <- el' "span" (text txt)
    ev <- mev
    return $ leftmost [txt <$ domEvent Click e, ev]
  ) (return never)

page :: MonadWidget t m => m (Event t T.Text)
page = do
  style [r|
body {
  background: url(310310.png);
  background-size: cover;
  color:white;
}
.dokuro {
  cursor:pointer;
}
|]
  let h2t = el "h2" . text
  h2t "toNat :: Prop → nat"
  h2t "toProp :: nat → Prop"
  h2t "Proof n m := m is proof for (toProp n)"
  h2t "Provable n := exists m. Proof n m"
  p <- elStyle "p" "font-size: 42px;" $ selectTree $ Node "Proof" [Node "toNat" [Node "P" []]]

  let h3t = el "h3" . text
  h3t "ن ن ك _ ي ر و ت س ت ك د _ و س ر ت"

  (_, (e, _)) <- elStyle' "div" "text-align:center;padding:30px;" $ do
    assetImgClass' "dokuro.png" "dokuro" (return ())

  return ("/nazo" <$ domEvent Click e)
