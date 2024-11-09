FROM haskell:9.8.2
RUN apt-get update
RUN apt-get install -y libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev ssh fonts-takao
COPY Gtk-3.0.gir /usr/share/gir-1.0/Gtk-3.0.gir
RUN apt-get install -y sudo
RUN useradd -m haskell -s /bin/bash
RUN gpasswd -a haskell sudo
RUN echo "haskell ALL=NOPASSWD: ALL" >> /etc/sudoers
# COPY ./ /root/src_temp/
# WORKDIR /root/src_temp
# RUN stack build --stack-yaml stack.linux.yaml
# RUN rm -rf $HOME/src_temp
RUN echo X11Forwarding yes >> /etc/ssh/sshd_config
RUN echo X11UseLocalhost no >> /etc/ssh/sshd_config
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
RUN echo exit | xauth
RUN echo "haskell:haskell" | chpasswd
USER haskell
# RUN echo "export PATH=$PATH" >> ~/.bashrc
RUN stack config set install-ghc --global false
RUN stack config set system-ghc --global true
RUN echo "export PATH=/opt/ghc/9.8.2/bin:\$PATH" >> ~/.bashrc
RUN sudo apt install -y neovim
WORKDIR /home/haskell
