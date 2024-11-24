#!/bin/bash

# stack version

export JSADDLE_WARP_PORT=11924

EXEPATH="$(stack exec --stack-yaml=./stack.linux.warp.yaml -- which RDWP-exe)"
stack build --stack-yaml=./stack.linux.warp.yaml
cd ./frontend/assets
"$EXEPATH"

