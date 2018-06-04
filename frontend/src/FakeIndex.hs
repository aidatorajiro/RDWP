{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module FakeIndex ( page ) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Map as M

import Reflex.Dom
import Elements (elID, h1ID', spanAbsP)

import Data.FileEmbed (embedFile)

import Util (moveWhenEvent)

import Data.Monoid ((<>))

data SpanType = Dollar | BindL | BindR

spanText :: SpanType -> T.Text
spanText Dollar = "$"
spanText BindL = "=<<"
spanText BindR = ">>="

spanList :: [(SpanType, Double, Double)]
spanList = [
  (Dollar, 10, 18),
  (Dollar, 15, 9),
  (Dollar, 13, 4),
  (Dollar, 3, 7),
  (Dollar, 8, 10),
  (Dollar, 31, 15),
  (Dollar, 4, 3),
  (Dollar, 50, 45),
  (Dollar, 23, 12),
  (BindL, 41, 19),
  (BindR, 30, 29),
  (BindL, 20, 43),
  (BindR, 32, 16),
  (BindL, 15, 18),
  (BindL, 12, 19),
  (BindL, 59, 19),
  (BindR, 65, 33),
  (BindR, 68, 37),
  (BindL, 51, 34),
  (BindR, 53, 50),
  (BindL, 70, 10),
  (BindR, 81, 13),
  (BindL, 12, 69),
  (BindR, 15, 76),
  (BindL, 24, 78),
  (BindL, 29, 72),
  (BindL, 21, 71),
  (BindL, 19, 79),
  (BindL, 71, 63),
  (BindR, 43, 81),
  (BindR, 89, 79),
  (BindR, 89, 90),
  (BindL, 85, 92),
  (BindL, 86, 86),
  (BindL, 80, 84),
  (BindR, 80, 84),
  (BindL, 89, 78),
  (BindR, 86, 78),
  (BindL, 81, 68),
  (BindL, 72, 57)]

css :: B.ByteString
css = $(embedFile "assets/css/FakeIndex.css")

-- PATH TO THE DEPTH
-- worry skate notice member person slender indicate fun urge chalk foster fiber chunk inch popular
page :: MonadWidget t m => m (Event t String)
page = elID "div" "wrapper" $ do
  mapM_ (\(t, x, y) -> spanAbsP (spanText t) x y) spanList
  spanAbsP "$" 10 10
  
  bind   <- h1ID' "bind" "=<<"
  dollar <- h1ID' "dollar" "$"
  fmap   <- h1ID' "fmap" "<$>"
  strict <- h1ID' "strict" "!"
  
  return $
    ("nmnmnmnmn" <$ domEvent Click bind) <>
    ("nazo"      <$ domEvent Click dollar) <>
    ("harituke"  <$ domEvent Click fmap) <>
    ("worry"     <$ domEvent Click strict)