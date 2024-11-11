{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Onsen where

import qualified Data.Text as T
import Elements
import Util
import Reflex.Dom
import Text.RawString.QQ

import Miscode

page :: MonadWidget t m => Integer -> m (Event t T.Text)
page n = do
  let bgcol = "473a37"
  style $ ".btn, canvas {cursor:pointer;} \n img {width:500px;height:500px;} \n body { text-align: center; background: #" <> bgcol <> "; margin: 0; padding: 0; color: #ffffff; font-family: \"Times New Roman\", serif; }"
  let centerstyle = "transform:translateY(-50%);position:absolute;top:50%;width:100%;"
  
  elStyle "div" centerstyle $ do
    ev <- case n of
      0 -> message 1 "♨️ o ♨️ n ♨️ s ♨️ e ♨️ n ♨️"
      1 -> do
        myTestCanvas02 500 500
        (e, _) <- elStyle' "div" (centerstyle <> "line-height:400px; font-size: 400px;z-index:10000;opacity:0.5;color:#FFFFFF;cursor:pointer;") (text "↩︎")
        return $ 2 <$ domEvent Click e
      2 -> do
        (e, _) <- assetImgClass' "nannkasoreppo.png" "btn" (return ())
        return $ 3 <$ domEvent Click e
      3 -> do
        (e, _) <- assetImgClass' "onsssaaas.png" "btn" (return ())
        return $ 4 <$ domEvent Click e
      4 -> do
        e <- simpleShader 500 500 [r|
precision mediump float;
varying vec2 vPos;
void main(void){
  gl_FragColor = vec4(vPos, 0.7, 1.0);
}
|] [r|
attribute vec2 position;
varying vec2 vPos;
uniform vec2 baa;
void main(void){
  vPos = position;
  gl_Position = vec4(position, baa);
}
|] [(2, [-1,-1,-1,1,1,1,1,1,1,-1,-1,-1])] [("baa", UniformFloat [5.67, 6.51])]
        return $ 5 <$ domEvent Click e
      5 -> do
        e <- simpleShader 500 500 [r|
precision mediump float;
varying vec2 vPos;
uniform vec2 baa;

vec2 compmul(vec2 a, vec2 b) {
	return vec2(a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x);
}

vec2 compdiv(vec2 a, vec2 b) {
	return vec2(a.x*b.x + a.y*b.y, - a.x*b.y + a.y*b.x)/(dot(b, b));
}

vec2 compexp(vec2 a) {
	return exp(a.x)*vec2(cos(a.y), sin(a.y));
}

vec2 compcos(vec2 a) {
	vec2 ia = compmul(a, vec2(0, 1));
	return 0.5*compexp(ia) + 0.5*compexp(-ia);
}

vec2 compsin(vec2 a) {
	vec2 ia = compmul(a, vec2(0, 1));
	return compmul(compexp(ia) - compexp(-ia), vec2(0, -0.5));
}

vec2 poly(vec2 a1) {
	vec2 a2 = compmul(a1, a1);
	vec2 a3 = compmul(a2, a1);
	vec2 a4 = compmul(a3, a1);
	vec2 a5 = compmul(a4, a1);
	return vec2(log(abs(a3.x)), a1.y);
}

vec2 poly_derivative(vec2 a1) {
	vec2 a2 = compmul(a1, a1);
	vec2 a3 = compmul(a2, a1);
	vec2 a4 = compmul(a3, a1);
	vec2 a5 = compmul(a4, a1);
	return compexp(a1)+vec2(1,5);
}

void main( void ) {
	// constant definition
	float pi = 3.1415926535897932384626433832795;
	float scale = 5.6;
	vec2 delta = baa;
	float colscale = 10.0;
  vec2 resolution = vec2(1.0, 1.0);

	// Newton's method
	vec2 position = (vPos  - vec2(1, 1))*vec2(scale,scale);
	vec2 val = position;
	
	for (int i = 0; i < 50; i++) {
		val = val - compmul(delta, compdiv(poly(val),poly_derivative(val)));
	}
	
	// output
	gl_FragColor = vec4( (val.x/length(val) + 1.0)/2.0, (val.y/length(val) + 1.0)/2.0, (atan(length(val)/colscale) + pi / 2.0) / pi, 1.0 );
}
|] [r|
attribute vec2 position;
varying vec2 vPos;
void main(void){
  vPos = position;
  gl_Position = vec4(position, 0, 1);
}
|] [(2, [-1,-1,-1,1,1,1,1,1,1,-1,-1,-1])] [("baa", UniformFloat [0.1,0.1])]
        return $ 6 <$ domEvent Click e
      _ -> message 0 "**** ****"
    return $ (\n -> T.pack $ "/onsen" <> show n) <$> ev
  
