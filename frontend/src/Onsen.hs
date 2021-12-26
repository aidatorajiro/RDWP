{-# LANGUAGE OverloadedStrings #-}

module Onsen where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

import Miscode

page :: MonadWidget t m => Integer -> m (Event t T.Text)
page n = do
  let bgcol = "473a37"
  style $ "body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  elStyle "div" "transform:translateY(-50%);position:absolute;top:50%;width:100%;" $ do
    ev <- case n of 
      0 -> message 1 "onsen ni kita"
      1 -> message 2 "onsen ni kita"
      _ -> message 0 "**** kouji chuu dayo! ****"
    return $ (\n -> T.pack $ "/onsen" <> show n) <$> ev
  