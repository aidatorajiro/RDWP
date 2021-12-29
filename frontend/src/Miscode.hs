{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Miscode where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ
import Language.Javascript.JSaddle (MonadJSM, new, jsg, getProp, (#))
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
import Data.List.Extra (allSame)
import Safe (atMay)

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

data UniformData = UniformInt [Int] | UniformFloat [Float] | UniformMatrix [Float]

-- | width, height, fragmentShader, vertexShader, attributes, uniforms
simpleShader :: MonadWidget t m => Int -> Int -> String -> String -> [(Int, [Float])] -> [(String, UniformData)] -> m (Element EventResult GhcjsDomSpace t)
simpleShader w h fragmentShader vertexShader attributes uniforms = do
  (e, _) <- el' "canvas" (return ())

  DOM.liftJSM $ runMaybeT $ do
    ce <- MaybeT $ DOM.castTo DOM.HTMLCanvasElement (_element_raw e)
    DOM.setHeight ce (fromIntegral h)
    DOM.setWidth ce (fromIntegral w)

    c <- MaybeT $ DOM.getContext ce ("webgl" :: String) ([] :: [DOM.JSVal])
    cgl <- MaybeT $ DOM.castTo DOM.WebGLRenderingContext c

    sh <- CG.createShader cgl CG.FRAGMENT_SHADER
    CG.shaderSource cgl (Just sh) (fragmentShader::String)
    CG.compileShader cgl (Just sh)

    sh' <- CG.createShader cgl CG.VERTEX_SHADER
    CG.shaderSource cgl (Just sh') (vertexShader::String)
    CG.compileShader cgl (Just sh')

    p <- CG.createProgram cgl
    CG.attachShader cgl (Just p) (Just sh)
    CG.attachShader cgl (Just p) (Just sh')
    CG.linkProgram cgl (Just p)
    CG.useProgram cgl (Just p)

    mapM_ (\(num, attr) -> do
      bufdata <- MaybeT $
          new (jsg ("Float32Array" :: String)) [attr]
          >>= getProp "buffer" . J.Object
          >>= DOM.castTo DOM.ArrayBuffer
      
      vb <- CG.createBuffer cgl
      CG.bindBuffer cgl CG.ARRAY_BUFFER (Just vb)
      CG.bufferData cgl CG.ARRAY_BUFFER (Just bufdata) CG.STATIC_DRAW
      
      loc <- CG.getAttribLocation cgl (Just p) ("position" :: String)
      CG.enableVertexAttribArray cgl (fromIntegral loc)
      CG.vertexAttribPointer cgl (fromIntegral loc) (fromIntegral num) CG.FLOAT False 0 0
      ) attributes

    mapM_ (\(name, uni) -> do
      loc <- CG.getUniformLocation cgl (Just p) (name :: String)
      case uni of
        UniformInt xs -> do
          arr <- MaybeT $
            new (jsg ("Int32Array" :: String)) [xs]
            >>= DOM.castTo DOM.Int32Array
          let fns = [CG.uniform1iv, CG.uniform2iv, CG.uniform3iv, CG.uniform4iv]
          (fns !! (length xs - 1)) cgl (Just loc) arr
        UniformFloat xs -> do
          arr <- MaybeT $
            new (jsg ("Float32Array" :: String)) [xs]
            >>= DOM.castTo DOM.Float32Array
          let fns = [CG.uniform1fv, CG.uniform2fv, CG.uniform3fv, CG.uniform4fv]
          --DOM.liftDOM (jsg ("console" :: String) # ("log" :: String) $ [DOM.toJSVal arr])
          (fns !! (length xs - 1)) cgl (Just loc) arr
        UniformMatrix xs -> do
          arr <- MaybeT $
            new (jsg ("Float32Array" :: String)) [xs]
            >>= DOM.castTo DOM.Float32Array
          fn <- MaybeT $ case length xs of
            4 -> return $ Just CG.uniformMatrix2fv
            9 -> return $ Just CG.uniformMatrix3fv
            16 -> return $ Just CG.uniformMatrix4fv
            _ -> return Nothing
          fn cgl (Just loc) False arr
      ) uniforms
    
    let lengths = map (\(a, b) -> length b `div` a) attributes

    numVertices <- MaybeT $ if allSame lengths then return (atMay lengths 0) else return Nothing

    CG.drawArrays cgl CG.TRIANGLES 0 (fromIntegral numVertices)
    CG.flush cgl
  
  return e

-- also, it is possible: performEvent ((DOM.liftJSM $ do ...) <$ ev)