$$$$$$$$$=<<>>==<<>>==<<=<<=<<>>=>>==<<>>==<<>>==<<>>==<<=<<=<<=<<=<<>>=>>=>>==<<=<<=<<>>==<<>>==<<=<<$
=<<
$<$>!







# memo

## Use vscode's Remote Container

Please increase docker's memory limit to 11GB.

1. Open project.
1. Click `><` icon in bottom right corner, and choose `Reopen in Container`.
1. Run `passwd` in the console and set the root password.
1. To run the application, use X11 forwarding. First, install X11 in the *host* computer and access the container via `ssh -X root@0.0.0.0 -p <forwarded port>`.
1. Then run `cd /workspace/frontend/assets`.
1. Then run `/workspace/.stack-work/install/x86_64-linux/*/*/bin/RDWP-exe`

## build

`stack build --stack-yaml=<stack.yaml or stack.macos.yaml or stack.ghcjs.yaml>`

or

`nix-build -E '(import ./reflex-platform {}).ghcjs.callPackage ./. {}' --option extra-binary-caches https://nixcache.reflex-frp.org --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="`

## dependencies

Dependencies for Ubuntu:

`sudo apt install libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev`

## docker (nix + ghcjs)

`docker build -f build-tools/docker-nix/Dockerfile .`

## docker (stack + ghc + X11 forwarding)

`docker build .`