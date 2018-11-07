{-# LANGUAGE OverloadedStrings #-}

module Ars where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom

message :: MonadWidget t m => T.Text -> m (Event t ())
message txt = do
  tickCount <- count =<< getTickEv 0.1
  let dt = fmap (\n -> T.take n txt) tickCount
  elStyle "div" "width:500px;font-size:24px;margin:auto;" (dynText dt)
  (e, _) <- elStyle' "div" "display:inline-block;margin-top:20px;" (text "↪︎")
  return (domEvent Click e)

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = elStyle "div" "transform:translateY(-50%);position:absolute;top:50%;width:100%;" $ do
  el "style" $ text "body { text-align: center; background: #821e0a; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  ev <- case n of 
    0 -> do
      el "h1" (text "Welcome To Arsnet")
      (e, _) <- elStyle' "h2" "margin-top: 100px; color: #F3C3C3;" (text "ENTER")
      return (domEvent Click e)
    1 -> message "Congratulations."
    2 -> message "The October labor lottery is complete. Your name has pulled."
    3 -> message "For immidiate placement, report to the Ministry of Transaction Verification at East Grestia Interface."
    4 -> message "An apartment will be provided for you and your family. Expect a rank 5.948504344881964 dwelling."
    5 -> message "Glory to Arsnet."
  return ((if n == 5 then "/ars_g" else T.pack $ "/ars" ++ show (n + 1)) <$ ev)