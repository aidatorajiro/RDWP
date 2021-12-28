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
  style $ ".btn {cursor:pointer;} \n img {width:500px;height:500px;} \n body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  let centerstyle = "transform:translateY(-50%);position:absolute;top:50%;width:100%;"
  
  elStyle "div" centerstyle $ do
    ev <- case n of
      0 -> message 1 "♨️ o ♨️ n ♨️ s ♨️ e ♨️ n ♨️"
      1 -> do
        myTestCanvas02 500 500
        (e, _) <- elStyle' "div" (centerstyle <> "line-height:400px; font-size: 400px;z-index:10000;opacity:0.5;color:#FFFFFF;cursor:pointer;") (text "↩︎")
        return $ 2 <$ domEvent Click e
      2 -> do
        (e, _) <- assetImgClass' "nannkasoreppo.png" "btn" (return ())
        return $ 3 <$ domEvent Click e
      3 -> do
        (e, _) <- assetImgClass' "onsssaaas.png" "btn" (return ())
        return $ 4 <$ domEvent Click e
      _ -> message 0 "**** ****"
    return $ (\n -> T.pack $ "/onsen" <> show n) <$> ev
  