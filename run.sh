#!/bin/sh

# stack version

PATH=/opt/cabal/3.2/bin:/opt/ghc/8.8.4/bin:$PATH

stack build
cd ./frontend/assets
../../.stack-work/install/*/*/*/bin/RDWP-exe
