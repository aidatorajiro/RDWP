{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom
import qualified Data.Map as M
import qualified Data.Text as T
import Data.Matrix
import Util ( getTickCount )
import Elements
import Data.Maybe ( fromMaybe )

-- | Apply laplacian filter to given array
lapl :: Matrix Double -> Matrix Double
lapl x = matrix (nrows x) (ncols x) (\(i, j) ->
    let a = fromMaybe 0 (safeGet (i - 1) j x)
        b = fromMaybe 0 (safeGet i (j - 1) x)
        c = x ! (i, j)
        d = fromMaybe 0 (safeGet i (j + 1) x)
        e = fromMaybe 0 (safeGet (i + 1) j x)
     in a + b - 4 * c + d + e
  )

-- | Run a wave equation. Steps one frame. Inputs are propagation speed, decay rate, current velocity, and current value. Output is a tuple of next velocity and value.
wave :: Double -> Double -> (Matrix Double, Matrix Double) -> (Matrix Double, Matrix Double)
wave k l (v, x) = 
  let v' = scaleMatrix l (scaleMatrix k (lapl x) + v)
      x' = v' + x
   in (v', x')

page :: MonadWidget t m => m (Event t T.Text)
page = do
  cnt <- getTickCount
  let pos = constDyn (50, 50)
  stat <- foldDynM (\_ vh -> do
      let (v, h) = wave 0.2 0.85 vh
      p <- sample (current pos)
      return (v, setElem 1 p h)
    ) (matrix 100 100 $ const 0, matrix 100 100 $ const 0) (updated cnt)
  elStyle "span" "position: fixed; top: 0px; left: 0px;" $ display cnt
  display stat
  return never
