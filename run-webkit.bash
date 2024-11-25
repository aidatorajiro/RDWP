#!/bin/bash

# stack version

export WEBKIT_DISABLE_DMABUF_RENDERER=1

EXEPATH="$(stack exec --stack-yaml=./stack.linux.webkit.yaml -- which RDWP-exe)"
stack build --stack-yaml=./stack.linux.webkit.yaml
cd ./frontend/assets
"$EXEPATH"
