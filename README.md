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

`stack build` for desktop app

or

`nix-build -A ghcjs.RDWP --option extra-binary-caches https://nixcache.reflex-frp.org --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="` for web

## run

`run.sh` or `node server.js` or `node server-wasm.js`

## build via docker

### docker (nix + ghcjs / wasm, for production)

1. `docker build -f build-tools/docker-nix/Dockerfile -t myimage .`
2. `docker run -itd --name mycontainer myimage`
3. `sh build.sh` or `sh build-wasm.sh`

### docker (stack + ghc + X11 forwarding, for development)

1. `docker-compose up`

#### Use nvim

1. `docker exec -it rdwp-myservice-1 bash` or `ssh haskell@localhost -p2222` (password: haskell)
2. `cd /workspace/frontend; nvim .`
3. Happy editing!

#### Use vscode's Remote Container

1. Access to `ssh haskell@localhost -p2222` (password: haskell)
2. Run `code /workspace/frontend`
3. Happy editing!


