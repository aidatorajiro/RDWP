rm -rf result-wasm
docker start mycontainer
docker exec mycontainer sh -c "sudo rm -rf /home/nix/RDWP"
docker cp ./ mycontainer:/home/nix/RDWP
docker exec mycontainer sh -c "sudo chown -R nix:nix /home/nix/RDWP"
docker exec mycontainer sh -c ". ~/e.sh; sudo rm -rf .stack-work frontend/.stack-work result result-1 result-2 result-wasm RDWP-exe.jsexe result-wasm.tar jsexe.tar; nix-build default-wasm.nix -A wasm.RDWP -o result-1; nix-build release-wasm.nix -A wasm-app -o result-2; sudo cp -rL result-2/ result-wasm/; tar cvf result-wasm.tar result-wasm"
docker cp mycontainer:/home/nix/RDWP/result-wasm.tar .
tar xvf result-wasm.tar
chmod -R 755 result-wasm
cp result-wasm/index.html result-wasm/404.html
cp frontend/assets/* result-wasm
rm result-wasm.tar
docker stop mycontainer
