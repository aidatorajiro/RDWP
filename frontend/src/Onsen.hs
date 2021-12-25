{-# LANGUAGE OverloadedStrings #-}

module Onsen where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

-- c"onsen"sus --
message :: MonadWidget t m => Int -> T.Text -> m (Event t Int)
message nextpage txt = do
  tickCount <- count =<< getTickEv 0.1
  let dt = fmap (`T.take` txt) tickCount
  elStyle "div" "width:500px;font-size:24px;margin:auto;" (dynText dt)
  (e, _) <- elStyle' "div" "display:inline-block;margin-top:20px;" (text "↪︎")
  return (nextpage <$ domEvent Click e)

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = elStyle "div" "transform:translateY(-50%);position:absolute;top:50%;width:100%;" $ do
  let bgcol = "473a37"
  style $ "body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  ev <- case n of 
    0 -> message 1 "onsen ni kita"
    1 -> message 2 "onsen ni kita"
    _ -> message 0 "**** kouji chuu dayo! ****"
  return $ (\n -> T.pack $ "/onsen" <> show n) <$> ev