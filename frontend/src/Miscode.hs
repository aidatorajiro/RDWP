{-# LANGUAGE OverloadedStrings #-}

module Miscode where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

message :: MonadWidget t m => Int -> T.Text -> m (Event t Int)
message nextpage txt = do
  tickCount <- count =<< getTickEv 0.1
  let dt = fmap (`T.take` txt) tickCount
  elStyle "div" "width:500px;font-size:24px;margin:auto;" (dynText dt)
  (e, _) <- elStyle' "div" "display:inline-block;margin-top:20px;" (text "↪︎")
  return (nextpage <$ domEvent Click e)