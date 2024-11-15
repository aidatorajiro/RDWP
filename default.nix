{system ? builtins.currentSystem, unstable ? import <nixos-unstable> {}} :
(import ./reflex-platform { inherit system; }).project ({pkgs, ...}: {
  packages = {
    RDWP = ./frontend;
  };
  shells = {
    ghc = ["frontend"];
    ghcjs = ["frontend"];
  };
})
