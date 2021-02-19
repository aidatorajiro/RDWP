{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Error404 ( page, list404 ) where

import Reflex.Dom
import Elements
import qualified Data.Text as T
import qualified Data.Map as M
import Text.RawString.QQ

css :: T.Text
css = [r|
img {
    width: 100%;
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
}
.link {
    cursor: pointer;
}
|]

list404 :: [Int]
list404 = [1, 2, 3, 4]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    assetImg "4041.png" (return ())
    el "br" (return ())
    (el, _) <- elAttr' "span" (M.singleton "class" "link") (text "★★★")
    return ("/index" <$ domEvent Click el)
