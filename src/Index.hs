{-# LANGUAGE OverloadedStrings #-}

module Index ( page ) where

import Control.Monad.Trans ( liftIO )

import qualified Data.Map as M
import qualified Data.Text as T
import Data.Time
import System.Random

import Reflex.Dom

import Util ( randomRDyn, getTickCount )
import Location ( move )

-- This page consists of two elements, "Hello, World!" text and progress bar.
-- The style of "Hello, World!" text changes at random.
-- The progress bar increases constantly, and when it complete, users jumped to "mensae".

page :: IO ()
page = mainWidget $ do
  -- get the current tick count
  tickcnt <- getTickCount

  -- get the initial random generator
  initGen <- liftIO getStdGen

  -- get the random generator which will be updated at each tick
  (rnd, gen) <- randomRDyn (1 :: Int, 800) initGen (updated tickcnt)

  -- define the style of "Hello, World!" text
  style <- foldDynMaybe (\r _ -> case r of
    400 -> Just "text-align: center;"
    255 -> Just "color: #FFFFFF;"
    100 -> Just "visibility: hidden;"
    0   -> Just "block: none;"
    1   -> Just ""
    11  -> Just ""
    111 -> Just ""
    _   -> Nothing) "" (updated rnd)

  let -- calculate the percentage of the length of the progress bar.
      percentage = min 100 . ( * 0.01 ) <$> tickcnt
      -- calculate the attribute for the "Hello, world!" text.
      attr_h1 = (\s -> M.fromList [("style", s)]) <$> style
      -- calculate the attribute for the progress bar.
      attr_div = (\p -> M.fromList [("style", T.pack $ "height: 1em; width: " ++ show p ++ "%; background: black;")]) <$> percentage

  -- When the progress bar complete, users will jump to "mensae".
  dyn =<< foldDynMaybe
    (\t _ ->
      if t == 10000 then
        Just (liftIO $ move "mensae")
      else Nothing)
    (return ())
    (updated tickcnt)

  -- elements
  elDynAttr "h1" attr_h1 $ text "Hello, world!"
  elDynAttr "div" attr_div blank