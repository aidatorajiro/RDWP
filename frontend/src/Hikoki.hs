{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Hikoki ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ
import Data.Maybe (fromMaybe, fromJust, isJust)
import Language.Javascript.JSaddle (liftJSM)
import Util (getTickEv)
import JSDOM (currentWindow)
import JSDOM.Generated.Element (getClientWidth)
import JSDOM.Custom.Window (getInnerWidth, getOuterWidth)
import Control.Monad (when)

svgFilter :: T.Text
svgFilter = [r|

|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    baseSVG 0 0 $ do
        svgEl "defs" $
            svgElID "filter" "nanika" $ do
                svgElAttr "feGaussianBlur" (M.fromList [("stdDeviation", "20")]) $ return ()

    style [r|
.hikoki {display: block; width: 100vw; height: 100vw; filter: url(#nanika);}
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
body,html {
    background: #310710;
    width: 100%;
    height: 100%;
    font-size: 24px;
}
|]
    let txt = ["あ", "か", "が", "み", "に", "目", "を", "細", "め", "る", "と", "死", "の", "も", "じ", "が"] :: [T.Text]


    assetImgClass "hikoki.jpg" "hikoki" (return ())
    elClass' "p" "hikokiwrap" $ do
        mapM_ (\x -> elAttr' "img" (M.fromList [("src", "hikoki_" <> T.pack (show x) <> ".jpg"), ("class", "hikokix"), ("alt", txt !! (x-1))]) (return ())) ([1..16] :: [Int])
    
    every_3_sec <- getTickEv 3
    let getwidth_monad = do
          w <- liftJSM currentWindow
          liftJSM $ getOuterWidth (fromJust w)
    width_dyn <- widgetHold getwidth_monad (getwidth_monad <$ every_3_sec)

    let soretext = (\x -> take (x `div` 7) $ cycle "それがどうした　") . max 300 <$> width_dyn
    elClass "p" "soresore" (dynText $ T.pack <$> soretext)
    assetImgClass "hikoki_17.jpg" "hikokiy" (return ())
    return never
