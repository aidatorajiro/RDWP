{-# LANGUAGE OverloadedStrings #-}

module Util where

import Control.Monad.Trans (liftIO)
import Data.Time
import System.Random

import qualified Data.ByteString as B

import Reflex.Dom
import Language.Javascript.JSaddle (JSM, JSVal, jsg, (#))
import Control.Monad (void)

-- | get ticking event
getTickEv :: MonadWidget t m => NominalDiffTime -> m (Event t TickInfo)
getTickEv d = do
  now <- liftIO getCurrentTime
  tickLossy d now

-- | dynamic random number and random number generator with given range and initial generator
randomRDyn :: (Random a, RandomGen g, MonadWidget t m) => (a, a) -> g -> Event t b -> m (Dynamic t a, Dynamic t g)
randomRDyn range initGen ev = splitDynPure <$> foldDyn (\_ (_, g) -> randomR range g) (randomR range initGen) ev

-- | run console.log
debugConsoleLog :: JSVal -> JSM ()
debugConsoleLog a = void $ jsg ("console" :: String) # ("log" :: String) $ [a]