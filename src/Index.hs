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
      attr_h1 = (\s -> M.fromList [("style", s)]) <$> style
      attr_div = (\p -> M.fromList [("style", T.pack $ "height: 1em; width: " ++ show p ++ "%; background: black;")]) <$> percentage

  dyn =<< foldDynMaybe
    (\t _ ->
      if t == 10000 then
        Just (liftIO $ move "mensae")
      else Nothing)
    (return ())
    (updated tickcnt)

  elDynAttr "h1" attr_h1 $ text "Hello, world!"
  elDynAttr "div" attr_div blank