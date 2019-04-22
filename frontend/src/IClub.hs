{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module IClub ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ

page :: MonadWidget t m => m (Event t T.Text)
page = do
    el "h1" $ text "虚数クラブへようこそ！"
    elClass "div" "i" $ text "i"
    return never