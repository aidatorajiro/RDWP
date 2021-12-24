{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Mn1 ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ

css :: T.Text
css = [r|
body {
    background: #2f1371;
}
.num0, .num1, .num2, .num3, .num4 {
    width: 18px;
    height: 18px;
    margin: 1px;
    padding: 0;
    display: inline-block;
    background-color: #FFFFFF;
}
.num0 {
    opacity: 0.1;
}
.num1 {
    opacity: 0.3;
}
.num2 {
    opacity: 0.5;
}
.num3 {
    opacity: 0.7;
}
.num4 {
    opacity: 0.9;
}
.input_num .output_num {
    margin-top:12px;
}
.arrrrr {
    color: white;
}
body {
    text-align: center;
}
.ev_del_count {
    opacity: 0.6;
    font-size: 33px;
    color: #03928F;
}
|]

-- | 5-adic arr to Integer
-- | example: [1, 2, 3] ----> 1*5^2 + 2*5 + 3 = 38
arrToNum :: [Integer] -> Integer
arrToNum = foldl (\x y -> x*5 + y) 0

-- | Integer to 5-adic arr
-- | example: 38 = 1*5^2 + 2*5 + 3 ----> [1, 2, 3]
numToArr :: Integer -> [Integer]
numToArr n
    | n < 5 = [n]
    | otherwise = numToArr (n `div` 5) ++ [n `mod` 5]

-- | Dynamic 5-adic arr to widget (white div tiles).
dynArrToWidget :: MonadWidget t m => Dynamic t [Integer] -> m (Event t ())
dynArrToWidget arr = dyn $
    foldr ((>>) . (\n ->
        elClass
        "div"
        ("num" <> T.pack (show n))
        (return ())
    )) (return ()) <$> arr

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    ev0 <- button "0"
    ev1 <- button "1"
    ev2 <- button "2"
    ev3 <- button "3"
    ev4 <- button "4"
    ev_del <- button "DEL"
    ev_del_count <- count ev_del

    input <- foldDyn (\n arr -> case n of
            5 -> drop 1 arr
            _ -> n : arr
        ) [] (leftmost [0 <$ ev0, 1 <$ ev1, 2 <$ ev2, 3 <$ ev3, 4 <$ ev4, 5 <$ ev_del])

    elClass "div" "input_num" (dynArrToWidget input)
    elClass "div" "input_num" (dynArrToWidget input)

    let input_num = arrToNum <$> input
    let output_num = (^2) <$> input_num
    let output = zipDynWith
            (\inp out -> drop (length out - length inp) out)
            input
            (numToArr <$> output_num)

    elClass "div" "output_num" (dynArrToWidget output)

    elClass "div" "arrrrr" (text "↓")

    elClass "div" "answer_num" (dynArrToWidget (constDyn $ replicate 20 4))

    elClass "div" "ev_del_count" $ display ev_del_count

    return $ fforMaybe (updated $ zipDyn output ev_del_count) (\(out, cnt) ->
            if length out == 20 then
                if all (== 4) out then
                    if cnt == 0 then
                        Just "/ars0"
                    else
                        Just "/skate"
                else Just "/nannkahenndayo"
            else Nothing
        )
