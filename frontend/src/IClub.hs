{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module IClub ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ
import Control.Monad (msum)
import Data.Maybe (fromMaybe)

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
    mel <- elClass "div" "i" $ do
        text "iiiiiii!"
        mapM (\n -> elClass "div" "kumi" $ do
            text "abc"
            assetImg "shori.png" (return ())
            case n of
                7 -> do
                    text "d"
                    (e, _) <- elStyle' "span" "color: #f2742b; cursor: pointer;" $ text "e"
                    text "f"
                    return ("/logg" <$ domEvent Click e)
                3 -> do
                    text "d"
                    (e, _) <- elStyle' "span" "color: #f22b74; cursor: pointer;" $ text "e"
                    text "f"
                    return ("/hikoki" <$ domEvent Click e)
                _ -> do
                    text "def"
                    return never
            ) [1..(10 :: Int)]
    mapM_ (\x -> do
        elClass "h2" "headline" (text $ "虚数クラブ名誉会員「" <> x <> "」さんのお言葉")
        elClass "div" "kuhaku" $ return ())
        ["", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "　"]

    return $ leftmost mel
