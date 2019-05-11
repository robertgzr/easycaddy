#!/bin/bash

set -e

ARCH="$1"

if [[ ! `uname -m` == "x86_64" ]]; then
    echo "not building on x86_64, this won't work then..."
    exit 1
fi

if [[ -z $ARCH ]]; then
    echo "need to set a target architecture"
    exit 1
fi

B=
if [[ `command -v buildah` ]]; then
    B="buildah bud"
else
    echo "buildah not found, trying docker..."
    if command -v docker; then
        B="docker build"
    else
        echo "docker not found, then this won't work..."
        exit 1
    fi
fi

set -x

case $ARCH in

    amd64)
        TAG="${CADDY_VERSION}-amd64"
        $B -t robertgzr/caddy:$TAG \
            --file Dockerfile \
            --build-arg CADDY_VERSION=$CADDY_VERSION \
            --build-arg GOARCH=amd64 \
            .
        ;;

    armv7hf)
        TAG="${CADDY_VERSION}-armv7hf"
        $B -t robertgzr/caddy:$TAG \
            --file Dockerfile.armv7hf \
            --build-arg CADDY_VERSION=$CADDY_VERSION \
            --build-arg GOARCH=arm --build-arg GOARM=7 \
            .
        ;;

esac
