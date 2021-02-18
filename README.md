$$$$$$$$$=<<>>==<<>>==<<=<<=<<>>=>>==<<>>==<<>>==<<>>==<<=<<=<<=<<=<<>>=>>=>>==<<=<<=<<>>==<<>>==<<=<<$
=<<
$<$>!




# memo

## build

`stack build --stack-yaml=<stack.linux.yaml or stack.macos.yaml or stack.ghcjs.yaml>`

or

`nix-build -E '(import ./reflex-platform {}).ghcjs.callPackage ./. {}' --option extra-binary-caches https://nixcache.reflex-frp.org --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="`

## dependencies

Dependencies for Ubuntu:

`sudo apt install libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev`

