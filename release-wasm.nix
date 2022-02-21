let
  project = import ./default-wasm.nix {};
  reflex-platform = import ./reflex-platform-wasm {};
  wasm-cross = reflex-platform.wasm-cross;
in {
  inherit wasm-cross;
  RDWP-ghc = project.ghc.RDWP;
  RDWP-wasm = project.wasm.RDWP;
  wasm-app = reflex-platform.build-wasm-app-wrapper
    "RDWP-exe" # Name of exe
    project.wasm.RDWP
    {};
}
