{-# LANGUAGE OverloadedStrings, QuasiQuotes, OverloadedLists #-}

module Hikoki ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ
import Data.Maybe (fromMaybe, fromJust, isJust)
import Language.Javascript.JSaddle (liftJSM)
import Util (getTickEv, dim)
import JSDOM (currentWindow)
import JSDOM.Generated.Element (getClientWidth)
import JSDOM.Custom.Window (getInnerWidth, getOuterWidth)
import Control.Monad (when)

page :: MonadWidget t m => m (Event t T.Text)
page = do
    let getFilePath x = "hikoki_" <> T.pack (show x) <> ".jpg"

    every_3_sec <- getTickEv 3
    let getwidth_monad = do
          w <- liftJSM currentWindow
          liftJSM $ getOuterWidth (fromJust w)
    width_dyn <- widgetHold getwidth_monad (getwidth_monad <$ every_3_sec)

    every_5_sec <- getTickEv 5
    five_cnt <- count every_5_sec
    let current_file_name = getFilePath . (+1) . flip mod 16 <$> five_cnt
    let getMaskWidth x = T.pack $ show (fromIntegral x * 1)
    let getMaskX x = T.pack $ show (fromIntegral x * 0)
    let getMaskY x = T.pack $ show (fromIntegral x * 0.1)

    d <- dim 0.1 0.15
    baseSVG 100 100 $ do
        svgEl "defs" $ do
            svgElID "filter" "boyaketekuru" $ do
                svgElDynAttr "feGaussianBlur" (
                    M.singleton "stdDeviation" . T.pack . show .
                        (\x -> (x + 1) * 20) <$> d) $ return ()
            svgElID "mask" "kakononoroi" $ do
                svgElDynAttr "image"
                    ((\x y -> [("href", y),
                               ("width", getMaskWidth x),
                               ("x", getMaskX x),
                               ("y", getMaskY x)])
                        <$> width_dyn <*> current_file_name)
                    (return ())
                return ()

    style [r|
.hikoki {
    display: block;
    width: 100vw;
    height: 100vw;
    filter: url(#boyaketekuru);
    mask: url(#kakononoroi);
    -webkit-mask: url(#kakononoroi);
}
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
        mapM_ (\x -> elAttr' "img"
            [("src", getFilePath x), ("class", "hikokix"), ("alt", txt !! (x-1))]
            (return ())) ([1..16] :: [Int])
    

    let soretext = (\x -> take (x `div` 7) $ cycle "それがどうした　") . max 300 <$> width_dyn
    elClass "p" "soresore" (dynText $ T.pack <$> soretext)
    assetImgClass "hikoki_17.jpg" "hikokiy" (return ())
    return never


