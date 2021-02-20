{ mkDerivation, reflex, reflex-dom, file-embed, cabal-macosx, jsaddle-warp, jsaddle-webkit2gtk, jsaddle-wkwebview, ghc, stdenv, darwin
, buildPackages, matrix, raw-strings-qq
}:

mkDerivation {
  pname = "RDWP";
  version = "0.1.0.0";
  src = builtins.filterSource (path: type: !(builtins.elem (baseNameOf path) [ ".git" "dist" ])) ./frontend;
  isExecutable = true;
  isLibrary = true;
  buildTools = [
    cabal-macosx
  ];
  buildDepends = [
    reflex
    reflex-dom
    matrix
    raw-strings-qq
    file-embed
  ] ++ (if ghc.isGhcjs or false then [
  ] else if stdenv.hostPlatform.isiOS then [
    jsaddle-wkwebview
    buildPackages.darwin.apple_sdk.libs.xpc
    (buildPackages.osx_sdk or null)
  ] else if stdenv.hostPlatform.isMacOS then [
    jsaddle-wkwebview
    jsaddle-warp
  ] else [
    jsaddle-webkit2gtk
    jsaddle-warp
  ]);
  postInstall = stdenv.lib.optionalString (ghc.isGhcjs or false) ''
    rm "$out/bin/reflex-todomvc" || true # This is not designed to be run from node, so don't let it be
  '';
  license = null;
}