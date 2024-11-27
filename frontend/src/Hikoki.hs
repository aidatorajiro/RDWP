{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Hikoki ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style [r|
.hikoki {width: 100%; height: 100%;}
.hikokix {

}
.hikokiy {
    display: block;
    margin: auto;
    margin-top: 20vw
}
.soresore {
    background: -webkit-linear-gradient(0deg, white, black, white, black, white, black, white, black, white, black, white, black, white, black, white, black);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}
body {
    background: #310710;
}
|]
    let txt = "あかがみに目を細めると死のもじが"
    assetImgClass "hikoki.jpg" "hikoki" (return ())
    el "p" $ do
        mapM_ (\x -> assetImgClass ("hikoki_" <> T.pack (show x) <> ".jpg") "hikokix" (return ())) [1..16]
        elClass "p" "soresore" (text "それがどうした　それがどうした　それがどうした　それがどうした　それがどうした　それがどうした　それがどうした")
        assetImgClass "hikoki_17.jpg" "hikokiy" (return ())
    return never
