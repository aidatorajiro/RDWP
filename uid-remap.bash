#!/bin/bash

export USER=haskell
export HOME=/home/$USER

if [ -d "/workspace" ]; then

    uid=$(stat -c "%u" /workspace/Dockerfile)
    gid=$(stat -c "%g" /workspace/Dockerfile)

    if [ "$uid" -ne 0 ]; then
        if [ "$(id -u $USER)" -ne $uid ]; then
            usermod -u $uid $USER
        fi
        if [ "$(id -g $USER)" -ne $gid ]; then
            getent group $gid >/dev/null 2>&1 || groupmod -g $gid $USER
        fi
    fi

    ghcup_uid=$(stat -c "%u" $HOME/.ghcup)
    ghcup_gid=$(stat -c "%g" $HOME/.ghcup)
    if [ $ghcup_uid -ne $uid ] || [ $ghcup_gid -ne $gid ]; then
        chown -R $uid:$gid $HOME
    fi
fi

exec setpriv --reuid=$USER --regid=$USER --init-groups "$@"