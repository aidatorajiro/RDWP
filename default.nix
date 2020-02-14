{ mkDerivation, reflex, reflex-dom, matrix, raw-strings-qq, file-embed, cabal-macosx, jsaddle-warp, jsaddle-webkit2gtk, jsaddle-wkwebview, ghc, stdenv, darwin
, buildPackages
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
  license = null;
}
