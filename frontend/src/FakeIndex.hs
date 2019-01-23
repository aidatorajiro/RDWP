{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module FakeIndex ( page ) where

import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

import Reflex.Dom
import Elements

import Data.Monoid ((<>))

css :: T.Text
css = [r|
*::selection {
  color: transparent;
	text-shadow: 0 0 8px #000;
}

#bind {
  text-align: center;
  font-size: 40px;
  width: 100px;
  margin: auto;
}

#dollar {
  font-size: 40px;
  position: absolute;
  left:10px;
  top: calc(50% - 70px);
  width:30px;
  height: 100px;
  line-height: 100px;
  margin: 0;
}

#fmap {
  font-size: 40px;
  position: absolute;
  right:10px;
  top: calc(50% - 30px);
  width:30px;
  height: 100px;
  line-height: 100px;
  margin: 0;
}

#strict {
  text-align: center;
  font-size: 40px;
  position: absolute;
  bottom: 0px;
  left: calc(50% - 15px);
  width: 30px;
  margin: auto;
}
|]

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

-- PATH TO THE DEPTH
-- worry skate notice member person slender indicate fun urge chalk foster fiber chunk inch popular
page :: MonadWidget t m => m (Event t T.Text)
page = do
  style css
  el "div" $ do
    mapM_ (\(t, x, y) -> spanAbsP (spanText t) x y) spanList
    spanAbsP "$" 10 10
    
    bind   <- h1ID' "bind" "=<<"
    dollar <- h1ID' "dollar" "$"
    fmap   <- h1ID' "fmap" "<$>"
    strict <- h1ID' "strict" "!"
    
    return $ leftmost [
        "/nmnmnmnmn" <$ domEvent Click bind,
        "/nazo"      <$ domEvent Click dollar,
        "/harituke"  <$ domEvent Click fmap,
        "/worry"     <$ domEvent Click strict
      ]
