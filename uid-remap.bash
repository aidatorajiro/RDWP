#!/bin/bash

export USER=haskell
export HOME=/home/$USER

if [ -d "/workspace" ]; then

    uid=$(stat -c "%u" /workspace/Dockerfile)
    gid=$(stat -c "%g" /workspace/Dockerfile)

    echo WORKSPACE UID $uid GID $gid

    if [ "$uid" -ne 0 ]; then
        if [ "$(id -u $USER)" -ne $uid ]; then
            usermod -u $uid $USER
        fi
        if [ "$(id -g $USER)" -ne $gid ]; then
            getent group $gid >/dev/null 2>&1 || groupmod -g $gid $USER
            chgrp -R $gid $HOME
        fi
    fi

    ghcup_uid=$(stat -c "%u" $HOME/.ghcup)
    ghcup_gid=$(stat -c "%g" $HOME/.ghcup)

    echo CONTAINER DATA UID $ghcup_uid GID $ghcup_gid
fi

exec setpriv --reuid=$USER --regid=$USER --init-groups "$@"