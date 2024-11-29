{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE RankNTypes #-}

module Elements where

import qualified Data.Text as T
import qualified Data.Map as M
import Data.Monoid ((<>))

import Reflex.Dom

-- | the SVG namespace URL.
svgNS :: Maybe T.Text
svgNS = Just "http://www.w3.org/2000/svg"

-- | A base svg tag with width, height and xmlns.
baseSVG :: (PostBuild t m, DomBuilder t m) => Int -> Int -> m a -> m a
baseSVG width height mon = do
    elDynAttrNS svgNS "svg" (constDyn $ M.fromList [("width", T.pack $ show width), ("height", T.pack $ show height), ("xmlns", "http://www.w3.org/2000/svg")]) mon

-- | a svg element
svgElDynAttr :: (PostBuild t m, DomBuilder t m) => T.Text -> Dynamic t (M.Map T.Text T.Text) -> m a -> m a
svgElDynAttr = elDynAttrNS svgNS

-- | a svg element with event result
svgElDynAttr' :: (PostBuild t m, DomBuilder t m) => T.Text -> Dynamic t (M.Map T.Text T.Text) ->  m a -> m (Element EventResult (DomBuilderSpace m) t, a)
svgElDynAttr' = elDynAttrNS' svgNS

-- | a svg element
svgEl :: (PostBuild t m, DomBuilder t m) => T.Text -> m a -> m a
svgEl tagname = elDynAttrNS svgNS tagname (constDyn [])

-- | a svg element with event result
svgEl' :: (PostBuild t m, DomBuilder t m) => T.Text -> T.Text ->  m a -> m (Element EventResult (DomBuilderSpace m) t, a)
svgEl' tagname idname = elDynAttrNS' svgNS tagname (constDyn [("id", idname)])

-- | a svg element
svgElAttr :: (PostBuild t m, DomBuilder t m) => T.Text -> M.Map T.Text T.Text -> m a -> m a
svgElAttr tagname attr = elDynAttrNS svgNS tagname (constDyn attr)

-- | a svg element with event result
svgElAttr' :: (PostBuild t m, DomBuilder t m) => T.Text -> M.Map T.Text T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
svgElAttr' tagname attr = elDynAttrNS' svgNS tagname (constDyn attr)

-- | a svg element
svgElID :: (PostBuild t m, DomBuilder t m) => T.Text -> T.Text -> m a -> m a
svgElID tagname idname = elDynAttrNS svgNS tagname (constDyn [("id", idname)])

-- | a svg element with event result
svgElID' :: (PostBuild t m, DomBuilder t m) => T.Text -> T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
svgElID' tagname idname = elDynAttrNS' svgNS tagname (constDyn [("id", idname)])

-- | A style tag.
style :: MonadWidget t m => T.Text -> m ()
style = el "style" . text

-- | an element with given css and widget
elStyle :: MonadWidget t m => T.Text -> T.Text -> m a -> m a
elStyle tagname = elAttr tagname . M.singleton "style"

-- | an element with given css and widget, also returns element itself
elStyle' :: MonadWidget t m => T.Text -> T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
elStyle' tagname = elAttr' tagname . M.singleton "style"

-- | an element with given dynamic style and widget.
elDynStyle :: MonadWidget t m => T.Text -> Dynamic t T.Text -> m a -> m a
elDynStyle tagname = elDynAttr tagname . fmap (M.singleton "style")

-- | an element with given dynamic style and widget, also returns element itself
elDynStyle' :: MonadWidget t m => T.Text -> Dynamic t T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
elDynStyle' tagname = elDynAttr' tagname . fmap (M.singleton "style")

-- | an element with given id and widget
elID :: MonadWidget t m => T.Text -> T.Text -> m a -> m a
elID tagname = elAttr tagname . M.singleton "id"

-- | an element with given id and widget, also returns element itself
elID' :: MonadWidget t m => T.Text -> T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
elID' tagname = elAttr' tagname . M.singleton "id"

-- | h1 with given text
h1 :: MonadWidget t m => T.Text -> m ()
h1 = el "h1" . text

-- | h1 with given text
h1' :: MonadWidget t m => T.Text -> m (Element EventResult (DomBuilderSpace m) t)
h1' = fmap fst . el' "h1" . text

-- | h1 with given id and text
h1ID :: MonadWidget t m => T.Text -> T.Text -> m ()
h1ID id = elID "h1" id . text

-- | h1 with given id and text, returns element itself
h1ID' :: MonadWidget t m => T.Text -> T.Text -> m (Element EventResult (DomBuilderSpace m) t)
h1ID' id = fmap fst . elID' "h1" id . text

-- | span element with absolute pixel position
spanAbs :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbs t x y = elAttr "span"
  (M.singleton "style" $ "position: absolute; top: " <> T.pack (show x) <> "px; left: " <> T.pack (show y) <> "px;")
  (text t)

-- | span element with absolute percentage position
spanAbsP :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbsP t x y = elAttr "span"
  (M.singleton "style" $ "position: absolute; top: " <> T.pack (show x) <> "%; left: " <> T.pack (show y) <> "%;")
  (text t)

spanAbsP' :: MonadWidget t m => T.Text -> Double -> Double -> m (Element EventResult (DomBuilderSpace m) t)
spanAbsP' t x y = fst <$> elAttr' "span"
  (M.singleton "style" $ "position: absolute; top: " <> T.pack (show x) <> "%; left: " <> T.pack (show y) <> "%;")
  (text t)

-- relative URL to asset URL
toAssetUrl :: T.Text -> T.Text
toAssetUrl txt = txt

-- | image object
assetImg :: MonadWidget t m => T.Text -> m a -> m a
assetImg = elAttr "img" . M.singleton "src" . toAssetUrl

-- | image object
assetImg' :: MonadWidget t m => T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
assetImg' = elAttr' "img" . M.singleton "src" . toAssetUrl

-- | image object
assetImgClass :: MonadWidget t m => T.Text -> T.Text -> m a -> m a
assetImgClass src cls = elAttr "img" [("src", toAssetUrl src), ("class", cls)]

-- | image object
assetImgClass' :: MonadWidget t m => T.Text -> T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
assetImgClass' src cls = elAttr' "img" [("src", toAssetUrl src), ("class", cls)]
