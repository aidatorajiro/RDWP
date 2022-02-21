{system ? builtins.currentSystem, unstable ? import <nixos-unstable> {}} :
(import ./reflex-platform-wasm { inherit system; }).project ({pkgs, ...}: {
  packages = {
    RDWP = ./frontend;
  };
  shells = {
    ghc = ["frontend"];
    ghcjs = ["frontend"];
    wasm = ["frontend"];
  };
  overrides = self: super: {
    matrix = pkgs.haskell.lib.dontCheck super.matrix; # immunity from tests
  };
})
