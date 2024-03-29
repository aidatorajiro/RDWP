{-# LANGUAGE OverloadedStrings #-}

module Ars where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Miscode

-- bg : 821e0a / 2f1371

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = elStyle "div" "transform:translateY(-50%);position:absolute;top:50%;width:100%;" $ do
  let bgcol = if n <= 5 then "821e0a" else "2f1371"
  style $ "body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  ev <- case n of 
    0 -> do
      el "h1" (text "Welcome To Arsnet")
      (e, _) <- elStyle' "h2" "margin-top: 100px; color: #F3C3C3;" (text "ENTER")
      return $ 1 <$ domEvent Click e
    1 -> message 2 "Congratulations."
    2 -> message 3 "A decentralized consensus has established: you are now assigned as a transaction coordinator at East Glacia Interface."
    3 -> message 4 "Please report immediately."
    4 -> message 5 "good luck ^_^"
    5 -> message 8717 "Glory to Arsnet."
    8717 -> message 8718 "Transactions with exactly four outputs are now considered non-standard. Any transactions which contain exactly four outputs MUST NOT be uploaded to the downstream mempool. / トランザクションバリデーターに通告：４アウトプットを持つトランザクションは今後ノンスタンダードとなります。４アウトプットを持つトランザクションを下流メモリプールに放出することは禁止されます。"
    _ -> message 0 "**** kouji chuu dayo! ****"
  return $ (\n -> T.pack $ "/ars" <> show n) <$> ev