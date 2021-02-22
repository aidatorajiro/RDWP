FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y curl xz-utils sudo
RUN adduser --disabled-password --gecos "" nix
RUN echo "nix:nix" | chpasswd
RUN echo "nix ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN addgroup nix sudo
RUN mkdir -m 0755 /nix && chown nix:nix /nix
RUN mkdir /etc/nix

RUN echo "substituters = https://cache.nixos.org https://nixcache.reflex-frp.org\ntrusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=\nhttp-connections = 40" | tee /etc/nix/nix.conf

USER nix

WORKDIR /home/nix

RUN curl -L https://nixos.org/nix/install | sh
RUN echo 'USER=nix; . /home/nix/.nix-profile/etc/profile.d/nix.sh;' > ~/e.sh

RUN mkdir RDWP

ADD ./ ./RDWP/

WORKDIR RDWP

RUN . ~/e.sh; nix-build -A ghcjs.RDWP