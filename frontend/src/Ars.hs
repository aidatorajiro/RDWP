{-# LANGUAGE OverloadedStrings #-}

module Ars where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom

message :: MonadWidget t m => Int -> T.Text -> m (Event t Int)
message nextpage txt = do
  tickCount <- count =<< getTickEv 0.1
  let dt = fmap (\n -> T.take n txt) tickCount
  elStyle "div" "width:500px;font-size:24px;margin:auto;" (dynText dt)
  (e, _) <- elStyle' "div" "display:inline-block;margin-top:20px;" (text "↪︎")
  return (nextpage <$ (domEvent Click e))

-- bg : 821e0a / 2f1371

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = elStyle "div" "transform:translateY(-50%);position:absolute;top:50%;width:100%;" $ do
  let bgcol = if n <= 5 then "821e0a" else "2f1371"
  style $ "body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  ev <- case n of 
    0 -> do
      el "h1" (text "Welcome To Arsnet")
      (e, _) <- elStyle' "h2" "margin-top: 100px; color: #F3C3C3;" (text "ENTER")
      return $ 1 <$ (domEvent Click e)
    1 -> message 2 "Congratulations."
    2 -> message 3 "The Toravember decentralized lottery is complete. Your name has pulled."
    3 -> message 4 "For immidiate placement, report to the Ministry of Transaction Verification at East Grestia Interface."
    4 -> message 5 "An apartment will be provided for you and your family. Expect a rank 5.948504344881964 dwelling."
    5 -> message 8717 "Glory to Arsnet."
    8717 -> message 8718 "Transactions with exactly four outputs are now considered non-standard. Any transactions which contain exactly four outputs MUST NOT be uploaded to the downstream mempool. / トランザクションバリデーターに通告：４アウトプットを持つトランザクションは今後ノンスタンダードとなります。４アウトプットを持つトランザクションを下流メモリプールに放出することは禁止されます。"
    _ -> message 0 "**** ****"
  return $ (\n -> T.pack $ "/ars" <> show n) <$> ev