{-# LANGUAGE OverloadedStrings #-}

module Index ( page ) where

import Control.Monad.Trans (liftIO)

import Reflex.Dom
import Data.Time
import System.Random

page :: IO ()
page = mainWidget $ do
  initGen <- liftIO getStdGen
  now <- liftIO getCurrentTime
  tickev <- tickLossy 0.01 now
  (rnd, gen) <- splitDynPure <$> foldDyn (\_ (_, g) -> randomR (1 :: Int, 10) g) (randomR (1, 10) initGen) tickev
  text "Hello, world!"