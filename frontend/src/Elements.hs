{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

module Elements where

import qualified Data.Text as T
import qualified Data.Map as M

import Reflex.Dom

-- | an element with given css and widget
elStyle :: MonadWidget t m => T.Text -> T.Text -> m a -> m a
elStyle tagname = elAttr tagname . M.singleton "style"

-- | an element with given css and widget, also returns element itself
elStyle' :: MonadWidget t m => MonadWidget t m => T.Text -> T.Text -> m a -> m (Element EventResult (DomBuilderSpace m) t, a)
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
h1' = el' "h1" . text

-- | h1 with given id and text
h1ID :: MonadWidget t m => T.Text -> T.Text -> m ()
h1ID id t = elID "h1" id (text t)

-- | h1 with given id and text, returns element itself
h1ID' :: MonadWidget t m => T.Text -> T.Text -> m (Element EventResult (DomBuilderSpace m) t)
h1ID' id t = fst <$> elID' "h1" id (text t)

-- | span element with absolute pixel position
spanAbs :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbs t x y = elAttr "span"
  (M.singleton "style" $ T.pack $ "position: absolute; top: " ++ show x ++ "px; left: " ++ show y ++ "px;")
  (text t)

-- | span element with absolute percentage position
spanAbsP :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbsP t x y = elAttr "span"
  (M.singleton "style" $ T.pack $ "position: absolute; top: " ++ show x ++ "%; left: " ++ show y ++ "%;")
  (text t)