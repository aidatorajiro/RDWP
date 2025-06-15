#!/bin/bash
set -euo pipefail

rm -rf RDWP-exe.jsexe result

pushd frontend
cabal build --project-file=./project-file-910 --with-hsc2hs=javascript-unknown-ghcjs-hsc2hs-9.12.2
cp -r dist-newstyle/build/javascript-ghcjs/ghc-9.12.2/RDWP-*/x/RDWP-exe/build/RDWP-exe/RDWP-exe.jsexe ../RDWP-exe.jsexe
popd
cp index-ghcjs/index.html RDWP-exe.jsexe/index.html
cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
cp frontend/assets/* RDWP-exe.jsexe

