{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Miscode where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ
import Language.Javascript.JSaddle (MonadJSM, new, jsg, getProp)
import qualified Language.Javascript.JSaddle as J
import Control.Monad.Trans.Maybe ( MaybeT(MaybeT, runMaybeT) )

import qualified GHCJS.Buffer as DOM
import qualified GHCJS.DOM.Types as DOM
import qualified GHCJS.DOM.Enums as DOM
import qualified GHCJS.DOM.Window as DOM
import qualified GHCJS.DOM.HTMLCanvasElement as DOM
import qualified GHCJS.DOM.WebGLRenderingContextBase as CG
import qualified GHCJS.DOM.CanvasRenderingContext2D as CC
import qualified JavaScript.TypedArray as DOM

message :: MonadWidget t m => Int -> T.Text -> m (Event t Int)
message nextpage txt = do
  tickCount <- count =<< getTickEv 0.1
  let dt = fmap (`T.take` txt) tickCount
  elStyle "div" "width:500px;font-size:24px;margin:auto;" (dynText dt)
  (e, _) <- elStyle' "div" "display:inline-block;margin-top:20px;" (text "↪︎")
  return (nextpage <$ domEvent Click e)

myTestCanvas01 :: MonadWidget t m => Int -> Int -> m ()
myTestCanvas01 w h = do
  (e, _) <- elStyle' "canvas" ("width:"<>T.pack (show w)<>"px; height:"<>T.pack (show h)<>"px;") (return ())
  DOM.liftJSM $ runMaybeT $ do
    ce <- MaybeT $ DOM.castTo DOM.HTMLCanvasElement (_element_raw e)
    c <- MaybeT $ DOM.getContext ce ("2d" :: String) ([] :: [DOM.JSVal])
    c2d <- MaybeT $ DOM.castTo DOM.CanvasRenderingContext2D c
    CC.setFillStyle c2d ("#FF0000" :: String)
    CC.fillRect c2d 0 0 500 500
  return ()

myTestCanvas02 :: MonadWidget t m => Int -> Int -> m (Element EventResult GhcjsDomSpace t)
myTestCanvas02 w h = do
  let shaderString = [r|precision mediump float;
varying vec3 vPos;
void main(void){
  gl_FragColor = vec4(vPos, 1.0);
}
|]
  let shaderString' = [r|attribute vec3 position;
varying vec3 vPos;
void main(void){
  vPos = position;
  gl_Position = vec4(position, 1.0);
}
|]
  (e, _) <- elStyle' "canvas" ("width:"<>T.pack (show w)<>"px; height:"<>T.pack (show h)<>"px;") (return ())
  DOM.liftJSM $ runMaybeT $ do
    ce <- MaybeT $ DOM.castTo DOM.HTMLCanvasElement (_element_raw e)
    c <- MaybeT $ DOM.getContext ce ("webgl" :: String) ([] :: [DOM.JSVal])
    cgl <- MaybeT $ DOM.castTo DOM.WebGLRenderingContext c

    sh <- CG.createShader cgl CG.FRAGMENT_SHADER
    CG.shaderSource cgl (Just sh) (shaderString::String)
    CG.compileShader cgl (Just sh)

    sh' <- CG.createShader cgl CG.VERTEX_SHADER
    CG.shaderSource cgl (Just sh') (shaderString'::String)
    CG.compileShader cgl (Just sh')

    p <- CG.createProgram cgl
    CG.attachShader cgl (Just p) (Just sh)
    CG.attachShader cgl (Just p) (Just sh')
    CG.linkProgram cgl (Just p)
    CG.useProgram cgl (Just p)

    bufdata <- MaybeT $
        new (jsg ("Float32Array" :: String))
        [[-1,-1,0, 1,-1,0, 1,1,0, 1,1,0, -1,1,0, -1,-1,0 :: Float]]
        >>= getProp "buffer" . J.Object
        >>= DOM.castTo DOM.ArrayBuffer
    
    vb <- CG.createBuffer cgl
    CG.bindBuffer cgl CG.ARRAY_BUFFER (Just vb)
    CG.bufferData cgl CG.ARRAY_BUFFER (Just bufdata) CG.STATIC_DRAW
    
    loc <- CG.getAttribLocation cgl (Just p) ("position" :: String)
    CG.enableVertexAttribArray cgl (fromIntegral loc)
    CG.vertexAttribPointer cgl (fromIntegral loc) 3 CG.FLOAT False 0 0

    CG.drawArrays cgl CG.TRIANGLES 0 6
    CG.flush cgl
  return e

-- | width, height, fragmentShader, vertexShader, vertices
simpleShader :: MonadWidget t m => Int -> Int -> String -> String -> [Float] -> [(String, Either (Either [Int] [Float]) [[Float]])] -> m (Element EventResult GhcjsDomSpace t)
simpleShader w h shaderString shaderString' vertices uniforms = do
  (e, _) <- elStyle' "canvas" ("width:"<>T.pack (show w)<>"px; height:"<>T.pack (show h)<>"px;") (return ())

  DOM.liftJSM $ runMaybeT $ do
    ce <- MaybeT $ DOM.castTo DOM.HTMLCanvasElement (_element_raw e)
    c <- MaybeT $ DOM.getContext ce ("webgl" :: String) ([] :: [DOM.JSVal])
    cgl <- MaybeT $ DOM.castTo DOM.WebGLRenderingContext c

    sh <- CG.createShader cgl CG.FRAGMENT_SHADER
    CG.shaderSource cgl (Just sh) (shaderString::String)
    CG.compileShader cgl (Just sh)

    sh' <- CG.createShader cgl CG.VERTEX_SHADER
    CG.shaderSource cgl (Just sh') (shaderString'::String)
    CG.compileShader cgl (Just sh')

    p <- CG.createProgram cgl
    CG.attachShader cgl (Just p) (Just sh)
    CG.attachShader cgl (Just p) (Just sh')
    CG.linkProgram cgl (Just p)
    CG.useProgram cgl (Just p)

    bufdata <- MaybeT $
        new (jsg ("Float32Array" :: String))
        [vertices]
        >>= getProp "buffer" . J.Object
        >>= DOM.castTo DOM.ArrayBuffer
    
    vb <- CG.createBuffer cgl
    CG.bindBuffer cgl CG.ARRAY_BUFFER (Just vb)
    CG.bufferData cgl CG.ARRAY_BUFFER (Just bufdata) CG.STATIC_DRAW
    
    loc <- CG.getAttribLocation cgl (Just p) ("position" :: String)
    CG.enableVertexAttribArray cgl (fromIntegral loc)
    CG.vertexAttribPointer cgl (fromIntegral loc) 3 CG.FLOAT False 0 0

    uni <- CG.getUniformLocation cgl (Just p) ("unif" :: String)

    CG.drawArrays cgl CG.TRIANGLES 0 (fromIntegral $ length vertices)
    CG.flush cgl
  
  return e

-- also, it is possible: performEvent ((DOM.liftJSM $ do ...) <$ ev)