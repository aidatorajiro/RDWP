{-# LANGUAGE OverloadedStrings #-} 
{-# LANGUAGE OverloadedLists #-} 
{-# LANGUAGE QuasiQuotes #-} 

module Shishi where
import qualified Data.Text as T
import Reflex.Dom
import Text.RawString.QQ
import Elements

css = [r|
body, html {
    background: #ffd257;
    width: 100%;
    height: 100%;
}
.shi {
    width: 100vw;
}
|]

page :: MonadWidget t m => Int -> m (Event t T.Text)
page n = do
  style css
  elAttr "img" [("class", "shi"), ("src", "shishi0.jpg")] $ do
    return ()
  return never
