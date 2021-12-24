FROM haskell:8.8.4
RUN apt-get update
RUN apt-get install -y libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev ssh fonts-takao
COPY Gtk-3.0.gir /usr/share/gir-1.0/Gtk-3.0.gir
COPY ./ $HOME/src_temp/
WORKDIR $HOME/src_temp
RUN stack build
RUN rm -rf $HOME/src_temp
RUN echo X11Forwarding yes >> /etc/ssh/sshd_config
RUN echo X11UseLocalhost no >> /etc/ssh/sshd_config
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
RUN echo exit | xauth
RUN echo "root:root" | chpasswd
RUN echo "export PATH=$PATH" >> ~/.bashrc