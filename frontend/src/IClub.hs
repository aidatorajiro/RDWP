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
    style [r|
@font-face {
	font-family: 'Untitled1';
	src: url(marukaite.ttf);
}
body {
    background: #20C0FF;
    color: #301000;
    overflow: scroll;
}
.i {
    margin-left: 53px;
}
.kumi {
    font-family: "Untitled1", serif;
    font-size: 80px;
}
.headline {
    color: #235711;
}
.kuhaku {
    margin-top: 88px;
}
|]
    el "h1" $ text "虚数クラブへようこそ！"
    elClass "div" "i" $ do
        text "iiiiiii!"
        mapM_ (\_ -> elClass "div" "kumi" $ do
            text "abc"
            assetImg "shori.png" (return ())
            text "def") [1..10]
    mapM_ (\x -> do
        elClass "h2" "headline" (text $ "虚数クラブ名誉会員「" <> x <> "」さんのお言葉")
        elClass "div" "kuhaku" $ return ())
        ["", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "　"]
    return never