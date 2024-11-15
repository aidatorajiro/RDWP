rm -rf RDWP-exe.jsexe
docker start mycontainer
docker exec mycontainer sh -c "sudo rm -rf /home/nix/RDWP; mkdir /home/nix/RDWP"
docker cp ./frontend mycontainer:/home/nix/RDWP
docker cp ./reflex-platform mycontainer:/home/nix/RDWP
docker cp ./stack.yaml mycontainer:/home/nix/RDWP
docker cp ./stack.yaml.lock mycontainer:/home/nix/RDWP
docker cp ./default.nix mycontainer:/home/nix/RDWP
docker exec mycontainer sh -c "sudo chown -R nix:nix /home/nix/RDWP"
docker exec mycontainer sh -c ". ~/e.sh; sudo rm -rf .stack-work frontend/.stack-work result result-1 result-2 result-wasm RDWP-exe.jsexe result-wasm.tar jsexe.tar; nix-build -A ghcjs.RDWP; cd result/bin; tar cvf /home/nix/RDWP/jsexe.tar RDWP-exe.jsexe"
docker cp mycontainer:/home/nix/RDWP/jsexe.tar ./
tar xvf jsexe.tar
chmod -R 755 RDWP-exe.jsexe
cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
cp frontend/assets/* RDWP-exe.jsexe
rm jsexe.tar
docker stop mycontainer

