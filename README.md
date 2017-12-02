# RDWP (Reflex Deep Web Project)

Reflex Deep Web Project is an implementation of mysterious website. The website looks like an adventure game. However, it is different from a game because there is no mission or meaning.

The purpose of this project is to restore mysterious spaces in the Internet. With developed search engines and enormous users of the Internet and monetization, its closed and mysterious sanctuary have been decreasing these days.

One of the most important features of this project is that the website is built using Reflex, a functional reactive programming framework for Haskell. Thanks to Reflex and Haskell, we can:
- use interesting libraries and features in Haskell (e.g. dynamic type inference, Template Haskell)
- feel the universe of functional system
- make not only the website but also the source code mysterious and playful (e.g. strict sign to all functions in the source code)

## Progress

There are few pages now.

## Build

1. Install The Haskell Tool Stack.
2. git clone http://github.com/aidatorajiro/RDWP
3. cd RDWP
4. stack setup
5. stack build

## Libraries
- dependent-sum-template
- ghcjs-dom
- ghcjs-dom-jsffi
- jsaddle
- prim-uniq
- ref-tf
- zenc
- file-embed

## Run

Please modify the variable "base" in bs-config.js so that it will match with your operation system and cabal version.

1. Build this program (see above).
2. npm install -g browser-sync connect-history-api-fallback
3. browser-sync start --config ./bs-config.js

This procedure will launch the http server which will take all of the connections to the generated index.html, since this web app is a Single Page Application.

## Source
Elements.hs - HTML element templates  
Error404.hs - routing fallback  
FakeIndex.hs - routed to "/" and ""  
Index.hs - routed to "index"  
LibMain.hs - router settings and app's main function  
Location.hs - path settings and functions about location  
Util.hs - misc utilities  
other files - individual pages