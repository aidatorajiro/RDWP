FROM haskell:8.8.4
RUN apt update
RUN apt install -y libwebkit2gtk-4.0-dev gobject-introspection libgirepository1.0-dev ssh
ADD Gtk-3.0.gir /usr/share/gir-1.0/Gtk-3.0.gir
RUN echo X11Forwarding yes >> /etc/ssh/sshd_config
RUN echo X11UseLocalhost no >> /etc/ssh/sshd_config
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
RUN echo exit | xauth