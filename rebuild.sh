docker cp ./ mycontainer:/home/nix/RDWP
docker exec mycontainer sh -c ". ~/e.sh; sudo rm -rf frontend/.stack-work; nix-build -A ghcjs.RDWP"
sudo docker cp mycontainer:/home/nix/RDWP/result/bin/RDWP-exe.jsexe ./
sudo cp RDWP-exe.jsexe/index.html RDWP-exe.jsexe/404.html
sudo cp frontend/assets/* RDWP-exe.jsexe
