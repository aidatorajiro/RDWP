{-# LANGUAGE OverloadedStrings #-}

module Index ( page ) where

import Control.Monad.Trans (liftIO)

import qualified Data.Map as M
import qualified Data.Text as T
import Reflex.Dom
import Data.Time
import System.Random

page :: IO ()
page = mainWidget $ do
  initGen <- liftIO getStdGen
  now <- liftIO getCurrentTime
  tickev <- tickLossy 0.01 now
  (rnd, gen) <- splitDynPure <$> foldDyn (\_ (_, g) -> randomR (1 :: Int, 800) g) (randomR (1, 10) initGen) tickev
  percentage <- foldDyn (\_ x -> if x < 100 then x + 0.1 else x) 0 tickev
  style <- foldDynMaybe (\r _ -> case r of
    255 -> Just "color: #FFFFFF;"
    250 -> Just "text-align: center;"
    100 -> Just "visibility: hidden;"
    0   -> Just "block: none;"
    _  -> Nothing) "" (updated rnd)
  let attr_h1 = (\s -> M.fromList [("style", s)]) <$> style
      attr_div = (\p -> M.fromList [("style", T.pack $ "height: 1em; width: " ++ show p ++ "%; background: black;")]) <$> percentage
  elDynAttr "h1" attr_h1 $ text "Hello, world!"
  elDynAttr "div" attr_div blank