{-# LANGUAGE OverloadedStrings #-}

module Nami ( page ) where

import Reflex.Dom
import qualified Data.Map as M
import qualified Data.Text as T
import Data.Matrix
import Util ( getTickEv )
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
  let n = 21
      init_mat = matrix n n $ const 0
      sanitize = min n . max 1

  h_ev <- (<$) (0,-1) <$> button "←"
  j_ev <- (<$) (1,0) <$> button "↓"
  k_ev <- (<$) (-1,0) <$> button "↑"
  l_ev <- (<$) (0,1) <$> button "→"

  pos <- foldDyn (\(a, b) (c, d) -> (sanitize $ a + c, sanitize $ b + d)) (11, 11) (leftmost [h_ev, j_ev, k_ev, l_ev])
  tickev <- getTickEv 0.5
  state <- foldDynM (\_ vh -> do
      let (v, h) = wave 0.2 0.85 vh
      p <- sample (current pos)
      return (v, setElem 10 p h)
    ) (init_mat, init_mat) tickev
  dyn $
    (\(v, h) ->
      sequence $
      matrix n n
        (\(i, j) ->
          let val = show (floor (h ! (i, j) * 100) :: Int) in
          elStyle
          "div"
          ("top: " <> T.pack (show (i * 16 + 60)) <> "px; left: " <> T.pack (show (j * 16)) <> "px; background: rgb(" <> T.pack val <> ", " <> T.pack val <> ", " <> T.pack val <> "); position: absolute; width:15px; height: 15px;")
          (return ()))) <$> state
  
  let s = (\(v, h) -> sum (toList h)) <$> state
  sa <- foldDyn (\b (a1, a2) -> (a2, b)) (-123.456, 789.012) (updated s)
  let saa = ((uncurry (-)) <$> sa)

  display sa
  display saa

  let pth = mapMaybe (\a -> if abs a < 0.01 then Just "/onsen0" else Nothing) (updated saa)

  return pth
