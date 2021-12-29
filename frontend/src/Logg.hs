{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE TemplateHaskell #-}

module Logg ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ
import Data.Char (ord)
import qualified Data.Map as M
import Data.FileEmbed (embedStringFile, makeRelativeToProject)
import Control.Monad(when, void)

css :: T.Text
css = [r|
@font-face {
	font-family: 'Untitled1';
	src: url(marukaite.ttf);
}
body {
    background: #1d9cc6;
}
span {
    width:32px;
    height:32px;
    padding: 8px;
    text-align: center;
    line-height: 32px;
    display: inline-block;
    opacity: 0.3;
}
span.c1 {
    background: #a215c1;
}
span.c2 {
    background: #15c1c1;
}
span.c3 {
    background: #5a8453;
}
span.c4 {
    background: #ea2a5d;
}
span.c5 {
    background: #eab72a;
}
span.c6 {
    background: #ea572a;
}
span.c7 {
    background: #2d2425;
}
span.c8 {
    background: #142d11;
}
span.c9 {
    background: #0a0e33;
}
span.c0 {
    background: #64bc42;
}
img {
    padding: 8px;
    cursor: pointer;
}
.dodekawrap {
    padding: 40px;
    text-align:center;
    font-size:144px;
}
.dodeka11, .dodeka22 {
    display: inline;
}
.dodeka22 {
    font-family: "Untitled1", serif;
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    
    (playbtn, _) <- assetImg' "pl.png" (return ())
    loggcut <- fmap (\n -> T.lines $ T.take 1000 $ T.drop (n*1000) logg) <$> count (domEvent Click playbtn)

    dyn $ (\lc->
        mapM_ (\x -> elClass "p" "line" $ do
        T.foldl (\a c -> do
                let m = T.pack $ show $ ord c `mod` 10
                a
                elClass "span" ("c" <> m) (text m)
            ) (return ()) x
        ) lc >>
        when (null lc) (
            elClass "div" "dodekawrap" (
                elClass "span" "dodeka1" (text "$ =") >>
                elClass "span" "dodeka2" (text "$")) >>
            elClass "div" "dodekawrap" (
                elClass "span" "dodeka11" (text "$ =") >>
                elClass "span" "dodeka22" (text "TA"))
        )) <$> loggcut
    
    return never

-- log ga bakete detekuru
logg :: T.Text
logg = T.pack $(makeRelativeToProject "log.txt" >>= embedStringFile)