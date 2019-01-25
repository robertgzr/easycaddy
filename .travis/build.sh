#!/bin/bash

B=

if [[ ! `uname -m` == "x86_64" ]]; then
    echo "not building on x86_64, this won't work then..."
    exit 1
fi

if [[ $B == "" && `command -v buildah` ]]; then
    B="buildah bud"
else
    echo "buildah not found, trying docker..."
fi

if [[ $B == "" ]]; then 
    if command -v docker; then
        B="docker build"
    else
        echo "docker not found, then this won't work..."
        exit 1
    fi
fi

TAG="${CADDY_VERSION}-amd64"
$B -t robertgzr/caddy:$TAG \
    --file Dockerfile \
    --build-arg CADDY_VERSION=$CADDY_VERSION \
    --build-arg GOARCH=amd64 \
    .

TAG="${CADDY_VERSION}-armv7hf"
$B -t robertgzr/caddy:$TAG \
    --file Dockerfile.armhf \
    --build-arg CADDY_VERSION=$CADDY_VERSION \
    --build-arg GOARCH=arm --build-arg GOARM=7 \
    .
