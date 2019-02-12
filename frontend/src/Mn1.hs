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
|]

-- | 5-adic arr to Integer
-- | example: [1, 2, 3] ----> 1*5^2 + 2*5 + 3 = 38
arr_to_num :: [Integer] -> Integer
arr_to_num = foldl (\x y -> x*5 + y) 0

-- | Integer to 5-adic arr
-- | example: 38 = 1*5^2 + 2*5 + 3 ----> [1, 2, 3]
num_to_arr :: Integer -> [Integer]
num_to_arr n
    | n < 5 = [n]
    | otherwise = num_to_arr (n `div` 5) ++ [n `mod` 5]

-- | Dynamic 5-adic arr to widget (white div tiles).
dyn_arr_to_widget :: MonadWidget t m => Dynamic t [Integer] -> m (Event t ())
dyn_arr_to_widget arr = dyn $
    (
        foldr (\x y -> x >> y) (return ()) .
        map (\n -> 
            elClass
            "div"
            (T.pack $ "num" ++ show n)
            (return ())
        )
    ) <$> arr

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    ev0 <- button "0"
    ev1 <- button "1"
    ev2 <- button "2"
    ev3 <- button "3"
    ev4 <- button "4"

    input <- foldDyn (:) [] (leftmost [0 <$ ev0, 1 <$ ev1, 2 <$ ev2, 3 <$ ev3, 4 <$ ev4])

    elClass "div" "input_num" (dyn_arr_to_widget input)
    elClass "div" "input_num" (dyn_arr_to_widget input)

    let input_num = arr_to_num <$> input
    let output_num = (^2) <$> input_num
    
    elClass "div" "output_num" (dyn_arr_to_widget $ num_to_arr <$> output_num)

    return never
