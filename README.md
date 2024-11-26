$$$$$$$$$=<<>>==<<>>==<<=<<=<<>>=>>==<<>>==<<>>==<<>>==<<=<<=<<=<<=<<>>=>>=>>==<<=<<=<<>>==<<>>==<<=<<$
=<<
$<$>!


# memo

## dependencies

Build dependencies for Ubuntu:

`libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev fonts-takao gir1.2-webkit2-4.0`

GHCUp recommended.

## build locally

linux only

### WARP

1. `cp stack.linux.warp.yaml stack.yaml`
2. `stack build`

### GHCJS 8

Install nix first.

1. `./build-nix-ghcjs-bare.bash`

### GHCJS 9

See <https://www.haskell.org/ghcup/guide/#ghc-js-cross-bindists-experimental> to setup experimental GHCJS. We need `javascript-unknown-ghcjs-ghc-9.10.0.20240413`.

1. `./build-cabal-910.bash`

### WEBKIT

1. `cp stack.linux.warp.yaml stack.yaml`
2. `stack build`

## run locally

linux only

### WARP

Hot reload using custom websocket server.

1. `SERVER_MODE=WARP node ./watch.js`

Or without hot reloading: `./run-warp.bash`

Access to `http://localhost:11923` via Google Chrome. (Firefox not supported)

### GHCJS 8 and 9

Hot reload using browser-sync.

1. `yarn install`
2. `SERVER_MODE=GHCJS node ./watch.js`

### WEBKIT

1. `./run-webkit.bash`

hot reloading is WIP.

## docker

### docker (nix + ghcjs / wasm, for production)

1. `docker build -f build-tools/docker-nix/Dockerfile -t myimage .`
2. `docker run -itd --name mycontainer myimage`
3. `./build-nix-ghcjs-docker.bash`

### docker (stack + ghcup + X11 forwarding, for development)

1. `docker-compose up`

#### Use nvim

1. `docker exec -it rdwp-myservice-1 bash` or `ssh haskell@localhost -p2222` (password: haskell)
2. `cd /workspace/frontend; nvim .`
3. Happy editing!

#### Use vscode's Remote Container

1. Access to `ssh haskell@localhost -p2222` (password: haskell)
2. Run `code /workspace/frontend`
3. Happy editing!


