{-# LANGUAGE OverloadedStrings #-}

module Elements where

import qualified Data.Text as T
import qualified Data.Map as M

import Reflex.Dom

-- h1 with given text
h1 :: MonadWidget t m => T.Text -> m ()
h1 = el "h1" . text

-- h1 with given text and id
h1ID :: MonadWidget t m => T.Text -> T.Text -> m ()
h1ID content id = elAttr "h1" (M.fromList [("id", id)]) $ text content
