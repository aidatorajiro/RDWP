{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import Elements
import Utila

message t = do
  getTickEv 0.01 

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = case n of 
  0 -> do
    elStyle "h1" "margin-top: 100px;" (text "Welcome To Arsnet")
    elStyle "h2" "margin-top: 100px; color: #231497;" (text "ENTER")
  1 -> message "Congratulations."
  2 -> message ""
  3 -> message ""