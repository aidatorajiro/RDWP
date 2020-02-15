{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Ubana where

import Reflex.Dom
import qualified Data.Text as T
import qualified Data.Map as M
import Elements
import Data.Matrix
import Data.Monoid ((<>))
import Text.RawString.QQ

data HaiEvent x = EvMove x | EvClick x

mkhais :: MonadWidget t m => Matrix T.Text -> m (Matrix (Element EventResult (DomBuilderSpace m) t))
mkhais mat = do
    let elems = matrix (nrows mat) (ncols mat) (\nm -> fst <$> (elClass' "div" "haihai" $ text (mat ! nm)))
    folded <- mapM id elems
    return folded

gethai :: Matrix T.Text -> (Int, Int) -> T.Text
gethai mat (n, m) = maybe "" id $ safeGet n m mat

coordToMatInd :: (Int, Int) -> (Int, Int)
coordToMatInd (n, m) = ((n - 200) `div` 32, (m - 200) `div` 32)

projectIndex :: (Int, Int) -> (Int, Int) -> (Int, Int)
projectIndex root@(r1, r2) indexToProject@(p1, p2) =
    let diff = (p1 - r1, p2 - r2) in
        if abs (fst diff) > abs (snd diff) then (p1, r2)
        else (r1, p2)

projectCoord :: (Int, Int) -> (Int, Int) -> (Int, Int)
projectCoord root coord = projectIndex root (coordToMatInd coord)

-- shisensho kanji&hiragana shudoudemusubu
page :: MonadWidget t m => m (Event t T.Text)
page = do
    style [r|
#overwrap {
    position: absolute;
    top: 0px;
    left: 0px;
    width: 100%;
    height: 100%;
}
#debug {
    opacity: 0.5;
}
|]

    (overwrap, _) <- elID' "div" "overwrap" (return ())

    let init_hais = matrix 10 10 (\(n, m) -> "あ")

    let evs = leftmost [EvClick <$> domEvent Mouseup overwrap, EvMove <$> domEvent Mousemove overwrap]

    stateDyn <- foldDyn (\ev st@(tmp, selects, hais) -> case ev of
        EvMove coord  -> case selects of
            []     -> st
            root:_ -> (projectCoord root coord, selects, hais)
        EvClick coord -> case selects of
            []     -> (coordToMatInd coord, [coordToMatInd coord], hais)
            root:_ -> (projectCoord root coord, projectCoord root coord:selects, hais)
        ) ((-1234, -1234), [], init_hais) evs

    elID "pre" "debug" $ display stateDyn

    return never
