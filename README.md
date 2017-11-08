# RDWP
## Build

1. Install The Haskell Tool Stack.
2. git clone http://github.com/aidatorajiro/RDWP
3. cd RDWP
4. stack setup
5. stack build

## Run

Please modify the variable "base" in bs-config.js so that it will match with your operation system and cabal version.

1. Build this program (see above).
2. npm install -g browser-sync connect-history-api-fallback
3. browser-sync start --config ./bs-config.js

This procedure will launch the http server which will take all of the connections to the generated index.html, since this web app is a Single Page Application.
