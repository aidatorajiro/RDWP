rm -rf RDWP-exe.jsexe result

pushd frontend
cabal build --project-file=./project-file-910
cp -r dist-newstyle/build/javascript-ghcjs/ghc-9.10.*/RDWP-*/x/RDWP-exe/build/RDWP-exe/RDWP-exe.jsexe ../RDWP-exe.jsexe
popd
cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
cp frontend/assets/* RDWP-exe.jsexe

