#!/bin/sh

# stack version

stack build
cd ./frontend/assets
../../.stack-work/install/x86_64-linux/*/*/bin/RDWP-exe
