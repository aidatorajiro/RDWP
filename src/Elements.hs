{-# LANGUAGE OverloadedStrings #-}

module Elements where

import qualified Data.Text as T
import qualified Data.Map as M

import Reflex.Dom

-- an element with given id and widget
elID :: MonadWidget t m => T.Text -> T.Text -> m a -> m a
elID tagname id = elAttr tagname (M.fromList [("id", id)])

-- h1 with given text
h1 :: MonadWidget t m => T.Text -> m ()
h1 = el "h1" . text

-- h1 with given id and text
h1ID :: MonadWidget t m => T.Text -> T.Text -> m ()
h1ID id t = elID "h1" id (text t)

-- span element with absolute pixel position
spanAbs :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbs t x y = elAttr "span"
  (M.fromList
    [("style",
      T.pack $ "position: absolute; top: " ++ show x ++ "px; left: " ++ show y ++ "px;")]
  ) (text t)

-- span element with absolute percentage position
spanAbsP :: MonadWidget t m => T.Text -> Double -> Double -> m ()
spanAbsP t x y = elAttr "span"
  (M.fromList
    [("style",
      T.pack $ "position: absolute; top: " ++ show x ++ "%; left: " ++ show y ++ "%;")]
  ) (text t)