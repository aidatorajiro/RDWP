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
  (e, _) <- elStyle' "div" "padding-top: 100px; font-size: 20px; text-align: center; height: 100%; width: 100%;" (dynText dt)
  return (domEvent Click e)

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = do
  ev <- case n of 
    0 -> do
      elStyle "h1" "margin-top: 100px;" (text "Welcome To Arsnet")
      (e, _) <- elStyle' "h2" "margin-top: 100px; color: #142366;" (text "ENTER")
      return (domEvent Click e)
    1 -> message "Congratulations."
    2 -> message ""
    3 -> message ""
  return ((T.pack $ "/ars" ++ show (n + 1)) <$ ev)