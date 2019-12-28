#!/bin/sh

stack build
cp ./frontend/assets/* ./frontend/.stack-work/dist/*/Cabal-*/build/RDWP-exe/
cd ./frontend/.stack-work/dist/*/Cabal-*/build/RDWP-exe
./RDWP-exe