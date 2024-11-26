#!/bin/bash

export USER=haskell
export HOME=/home/$USER

if [ -d "/workspace" ]; then

    uid=$(stat -c "%u" /workspace)
    gid=$(stat -c "%g" /workspace)

    if [ "$uid" -ne 0 ]; then
        if [ "$(id -g $USER)" -ne $gid ]; then
            getent group $gid >/dev/null 2>&1 || groupmod -g $gid $USER
            chgrp -R $gid $HOME
        fi
        if [ "$(id -u $USER)" -ne $uid ]; then
            usermod -u $uid $USER
        fi
    fi

fi

exec setpriv --reuid=$USER --regid=$USER --init-groups "$@"