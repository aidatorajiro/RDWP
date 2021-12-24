#!/bin/sh

# stack version

stack build --stack-yaml=stack.macos.yaml
cp frontend/assets/* .stack-work/install/x86_64-osx/*/*/bin
cd .stack-work/install/x86_64-osx/*/*/bin
touch index.html
./RDWP-exe
