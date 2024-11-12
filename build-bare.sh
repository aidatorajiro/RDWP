rm -rf RDWP-exe.jsexe result
nix-build -A ghcjs.RDWP --option extra-binary-caches https://nixcache.reflex-frp.org --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
OUTDIR="$(pwd)"
pushd result/bin
  tar cvf "${OUTDIR}/jsexe.tar" RDWP-exe.jsexe
popd
tar xvf jsexe.tar
chmod -R 755 RDWP-exe.jsexe
cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
cp frontend/assets/* RDWP-exe.jsexe
rm jsexe.tar

