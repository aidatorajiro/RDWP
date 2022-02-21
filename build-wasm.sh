sudo rm -rf result-wasm
docker start mycontainer
docker cp ./ mycontainer:/home/nix/RDWP
docker exec mycontainer sh -c ". ~/e.sh; sudo rm -rf frontend/.stack-work result result-1 result-2 result-copy; nix-build default-wasm.nix -A wasm.RDWP -o result-1; nix-build release-wasm.nix -A wasm-app -o result-2; sudo cp -rL result-2/ result-copy/"
sudo docker cp mycontainer:/home/nix/RDWP/result-copy ./result-wasm
sudo cp result-wasm/index.html result-wasm/404.html
sudo cp frontend/assets/* result-wasm
sudo chmod -R 755 result-wasm
sudo chown -R $USER result-wasm
