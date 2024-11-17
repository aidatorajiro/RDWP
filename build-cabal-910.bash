#!/bin/bash

rm -rf RDWP-exe.jsexe result

pushd frontend
cabal build --project-file=./project-file-910 --with-hsc2hs=javascript-unknown-ghcjs-hsc2hs-9.10.0.20240413
cp -r dist-newstyle/build/javascript-ghcjs/ghc-9.10.*/RDWP-*/x/RDWP-exe/build/RDWP-exe/RDWP-exe.jsexe ../RDWP-exe.jsexe
popd
cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
cp frontend/assets/* RDWP-exe.jsexe

