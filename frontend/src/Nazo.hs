{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Nazo ( page ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style [r|
body {
    margin: 20px;
}
h1 {
    text-align: center;
}
#imgwrap {
    grid-template-columns: auto auto;
    grid-template-rows: 200px 200px;
}
#expe {
    
}
#mode {

}
|]
    el "h1" (text "nlognを讃えよ！")
    elID "div" "imgwrap" $ do
        elAttr "img" (M.fromList [("src", "qs_expectation.png"), ("id", "expe")]) (return ())
        elAttr "img" (M.fromList [("src", "qs_mode.png"), ("id", "mode")]) (return ())
    return never
