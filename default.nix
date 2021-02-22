{system ? builtins.currentSystem, unstable ? import <nixos-unstable> {}} :
(import ./reflex-platform { inherit system; }).project ({pkgs, ...}: {
  useWarp = true;
  packages = {
    RDWP = ./frontend;
  };
  shells = {
    ghc = ["frontend"];
    ghcjs = ["frontend"];
    wasm = ["frontend"];
  };
  overrides = self: super: {
    mmorph = self.callHackage "mmorph" "1.1.3" {}; # special hack for mmorph
    matrix = pkgs.haskell.lib.dontCheck super.matrix; # immunity from tests
    reflex = pkgs.haskell.lib.dontCheck super.reflex; # immunity from tests
    reflex-dom-core = pkgs.haskell.lib.dontCheck super.reflex-dom-core; # immunity from tests
    loop = pkgs.haskell.lib.dontCheck super.loop; # immunity from tests
  };
})