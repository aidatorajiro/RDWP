{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module ArsGame where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

css :: T.Text
css = [r|
body {
    background: #2f1371;
}
#main {
  display: grid;
  grid-template-columns: 40px auto 80px auto 40px;
  grid-template-rows: 40px 100px 100px 100px 100px 100px 100px 100px 100px 40px;
  width: 100%;
}
|]

messages = ["Transactions with exactly four outputs are now considered non-standard. Any transactions which contain exactly four outputs MUST NOT be uploaded to the downstream mempool. / トランザクションバリデーターに通告：４アウトプットを持つトランザクションは今後ノンスタンダードとなります。４アウトプットを持つトランザクションを下流メモリプールに放出することは禁止されます。"]

page :: MonadWidget t m => m (Event t T.Text)
page = do
  style css
  return never
