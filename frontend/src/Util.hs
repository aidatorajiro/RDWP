{-# LANGUAGE OverloadedStrings #-}

module Util where

import Control.Monad.Trans (liftIO)
import Data.Time
import System.Random
import Data.FileEmbed (embedFile)
import Location (move)

import qualified Data.ByteString as B

import Reflex.Dom

getTickCount :: (MonadWidget t m, Num a) => m (Dynamic t a)
getTickCount = do
  now <- liftIO getCurrentTime
  tickev <- tickLossy 0.01 now
  count tickev

-- dynamic random number and random number generator with given range and initial generator
randomRDyn :: (Random a, RandomGen g, MonadWidget t m) => (a, a) -> g -> Event t b -> m (Dynamic t a, Dynamic t g)
randomRDyn range initGen ev = splitDynPure <$> foldDyn (\_ (_, g) -> randomR range g) (randomR range initGen) ev

-- move when event fire
moveWhenEvent :: MonadWidget t m => Event t a -> String -> m ()
moveWhenEvent ev lc = do
  dyn =<< foldDyn
    (\_ _ -> liftIO $ move lc)
    (return ()) ev
  return ()