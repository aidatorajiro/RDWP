{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Harituke ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style "body { background: black; color: white; text-align: center;} \n section:hover { opacity: 0.6; cursor: pointer; } \n img { width: 200px; } \n h1 {margin-top: 30px;} \n input {display: block; margin: auto; width: 500px;}"
    h1 "わーーーーーーーぷぽいんと"
    inp <- inputElement def
    (el, _) <- el' "section" $ do
      mapM (\n -> assetImg ("404" <> (T.pack $ show n) <> ".png") (return ())) [1..9]
    return (tag (current $ _inputElement_value inp) (domEvent Click el))
