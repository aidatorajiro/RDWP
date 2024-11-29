{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE FlexibleContexts #-}

module Util where

import Control.Monad.Trans (liftIO, MonadIO)
import Data.Time
import System.Random

import qualified Data.ByteString as B

import Reflex.Dom
import Language.Javascript.JSaddle (JSM, JSVal, jsg, (#), function)
import Control.Monad (void)
import qualified Witherable as W
import Data.Maybe (fromJust, isJust)
import Control.Monad.Fix (MonadFix)

-- | dimming function using sin function
-- | deltatime = time delta for each tick
-- | speed = change speed
timeElapsed :: (Reflex t, MonadHold t m, MonadIO m, PostBuild t m, PerformEvent t m, TriggerEvent t m, MonadIO (Performable m), MonadFix m) => NominalDiffTime -> m (Dynamic t Double)
timeElapsed deltatime = do
  ct <- liftIO getCurrentTime
  ev <- tickLossy deltatime ct
  cnt <- count ev
  return $ (\x -> x * realToFrac deltatime) <$> cnt

-- | dimming function using sin function
-- | deltatime = time delta for each tick
-- | speed = change speed
dim :: (Reflex t, MonadHold t m, MonadIO m, PostBuild t m, PerformEvent t m, TriggerEvent t m, MonadIO (Performable m), MonadFix m) => NominalDiffTime -> Double -> m (Dynamic t Double)
dim deltatime speed = do
  cnt <- timeElapsed deltatime
  return (sin . (*speed) <$> cnt)

-- | widgetHold with no operation at init state
widgetHoldNoop :: (Adjustable t m, MonadHold t m) => Event t (m ()) -> m (Dynamic t ())
widgetHoldNoop = widgetHold (return ())

-- | flatten Event t (Maybe x)
flatEventMaybe :: Reflex t => Event t (Maybe x) -> Event t x
flatEventMaybe ev = fromJust <$> W.filter isJust ev

-- | try action for n times (incl. delay for the next action and fail threshold)
tryActions :: MonadWidget t m => NominalDiffTime -> Int -> m (Event t (), Event t x) -> m (Event t x)
tryActions diff threshold action = mdo
      md <- holdDyn action (action <$ sh'')
      ee <- dyn md
      sh <- switchHold never (fst <$> ee)
      sh' <- delay 1 sh
      cnt <- Reflex.Dom.count sh'
      let sh'' = gate ((< threshold) <$> current cnt) sh'
      switchHold never (snd <$> ee)

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
