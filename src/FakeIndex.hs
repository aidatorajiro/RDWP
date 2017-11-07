{-# LANGUAGE OverloadedStrings #-}

module FakeIndex ( page ) where

import qualified Data.Text as T

import Reflex.Dom

import Util (getTickCount)

page :: IO ()
page = mainWidget $ do
  tickcnt <- getTickCount
  dynText $ T.pack . show <$> tickcnt