{-# LANGUAGE OverloadedStrings #-}

module Util where

import Control.Monad.Trans (liftIO)
import Data.Time
import System.Random

import qualified Data.ByteString as B

import Reflex.Dom

getTickCount :: MonadWidget t m => m (Dynamic t Int)
getTickCount = do
  now <- liftIO getCurrentTime
  tickev <- tickLossy 0.01 now
  count tickev

-- dynamic random number and random number generator with given range and initial generator
randomRDyn :: (Random a, RandomGen g, MonadWidget t m) => (a, a) -> g -> Event t b -> m (Dynamic t a, Dynamic t g)
randomRDyn range initGen ev = splitDynPure <$> foldDyn (\_ (_, g) -> randomR range g) (randomR range initGen) ev