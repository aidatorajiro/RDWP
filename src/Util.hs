{-# LANGUAGE OverloadedStrings #-}

module Util where

import Control.Monad.Trans (liftIO)
import Data.Time
import System.Random

import Reflex.Dom

getTickCount :: (MonadWidget t m, Num a) => m (Dynamic t a)
getTickCount = do
  now <- liftIO getCurrentTime
  tickev <- tickLossy 0.01 now
  count tickev

randomRDyn :: (Random a, RandomGen g, MonadWidget t m) => (a, a) -> g -> Event t b -> m (Dynamic t a, Dynamic t g)
randomRDyn range initGen ev = splitDynPure <$> foldDyn (\_ (_, g) -> randomR range g) (randomR range initGen) ev