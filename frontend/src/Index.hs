{-# LANGUAGE OverloadedStrings #-}

module Index ( page ) where

import Control.Monad.Trans ( liftIO )

import qualified Data.Map as M
import qualified Data.Text as T
import Data.Time
import System.Random

import Reflex.Dom

import Util ( randomRDyn, getTickCount, moveWhenEvent )

page :: IO ()
page = mainWidget $ do
  tickcnt <- getTickCount

  initGen <- liftIO getStdGen
  (rnd, gen) <- randomRDyn (1 :: Int, 800) initGen (updated tickcnt)
  style <- foldDynMaybe (\r _ -> case r of
    400 -> Just "text-align: center;"
    255 -> Just "color: #FFFFFF;"
    100 -> Just "visibility: hidden;"
    0   -> Just "block: none;"
    1   -> Just ""
    11  -> Just ""
    111 -> Just ""
    _   -> Nothing) "" (updated rnd)

  let percentage = min 100 . ( * 0.01 ) <$> tickcnt
      attr_h1 = M.singleton "style" <$> style
      attr_div = (\p -> M.singleton "style" $ T.pack $ "height: 1em; width: " ++ show p ++ "%; background: black;") <$> percentage

  moveWhenEvent (ffilter (== 10000) $ updated tickcnt) "mensae"

  elDynAttr "h1" attr_h1 $ text "Hello, world!"
  elDynAttr "div" attr_div blank