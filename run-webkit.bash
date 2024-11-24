#!/bin/bash

# stack version

EXEPATH="$(stack exec --stack-yaml=./stack.linux.webkit.yaml -- which RDWP-exe)"
stack build --stack-yaml=./stack.linux.webkit.yaml
cd ./frontend/assets
"$EXEPATH"
