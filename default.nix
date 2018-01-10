{ mkDerivation, ghc, base, bytestring, containers, file-embed
, mtl, parsec, random, reflex, reflex-dom
, text, time, stdenv
, haskell-src-exts, haskell-src-meta
}:
mkDerivation {
  pname = "RDWP";
  version = "0.1.0.0";
  src = builtins.filterSource (path: type: !(builtins.elem (baseNameOf path) [ ".git" "dist" ])) ./.;
  libraryHaskellDepends = [
    base bytestring containers file-embed mtl
    parsec random reflex reflex-dom text time
    haskell-src-exts haskell-src-meta
  ]);
  configureFlags = [
    "-f-use-template-haskell"
  ];
  homepage = "https://github.com/aidatorajiro/RDWP";
  description = "A functional deep web implementation";
  license = stdenv.lib.licenses.mit;
}