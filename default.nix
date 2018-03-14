# default.nix
(import ./reflex-platform {}).project ({ pkgs, ... }: {
  packages = {
    frontend = ./frontend;
  };

  shells = {
    ghcjs = ["frontend"];
  };
})
