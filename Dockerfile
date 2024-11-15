FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y python3 curl sudo libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev ssh fonts-takao gir1.2-webkit2-4.0

RUN useradd -m haskell -s /bin/bash
RUN gpasswd -a haskell sudo
RUN echo "haskell ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo X11Forwarding yes >> /etc/ssh/sshd_config
RUN echo X11UseLocalhost no >> /etc/ssh/sshd_config
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
RUN echo exit | xauth
RUN echo "haskell:haskell" | chpasswd

USER haskell
WORKDIR /home/haskell

RUN sudo apt-get install -y build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
RUN echo ". ~/.ghcup/env; export XDG_DATA_HOME=\$HOME/.local/share; export XDG_CONFIG_HOME=\$HOME/.config; export PATH=/opt/nvim-linux64/bin:\$PATH" > ~/e.sh
RUN echo ". \$HOME/e.sh" >> ~/.bashrc
RUN . ~/e.sh; ghcup install ghc 9.8.2
RUN . ~/e.sh; ghcup install cabal
RUN . ~/e.sh; ghcup install stack
RUN . ~/e.sh; ghcup install hls

RUN sudo apt-get install -y git
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
RUN sudo rm -rf /opt/nvim
RUN sudo tar -C /opt -xzf nvim-linux64.tar.gz
RUN rm nvim-linux64.tar.gz
RUN mkdir /home/haskell/.config
COPY ./nvim-config /home/haskell/.config/nvim
RUN sudo chown -R haskell:haskell ~/.config/nvim/
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN echo "export NVM_DIR=\$HOME/.nvm; . \$NVM_DIR/nvm.sh; . ~/.ghcup/env; export XDG_DATA_HOME=\$HOME/.local/share; export XDG_CONFIG_HOME=\$HOME/.config; export PATH=/opt/nvim-linux64/bin:\$PATH" > ~/e.sh
RUN . ~/e.sh; nvm install 22
RUN curl -fLo /home/haskell/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN . ~/e.sh; nvim +PlugInstall +qall

RUN . ~/e.sh; npm install -g yarn;

