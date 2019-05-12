#!/bin/bash

set -e

ARCH=${1:-amd64}

if [[ ! `uname -m` == "x86_64" ]]; then
    echo "not building on x86_64, then this won't work!"
    exit 1
fi


B="buildah bud"
if ! command -v buildah; then
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
        $B \
            --file=Dockerfile \
            --tag=docker.io/$DOCKER_USERNAME/caddy:$CADDY_VERSION-$ARCH \
            --build-arg BUILD_DATE=`date -u +%Y-%m-%dT%H:%M:%SZ` \
            --build-arg CADDY_VERSION=$CADDY_VERSION \
            --build-arg GOOS=linux \
            --build-arg GOARCH=amd64 \
            .
        ;;

    armv7hf)
        $B \
            --file=Dockerfile \
            --tag=docker.io/$DOCKER_USERNAME/caddy:$CADDY_VERSION-$ARCH \
            --build-arg BUILD_DATE=`date -u +%Y-%m-%dT%H:%M:%SZ` \
            --build-arg CADDY_VERSION=$CADDY_VERSION \
            --build-arg GOOS=linux \
            --build-arg GOARCH=arm --build-arg GOARM=7 \
            .
        ;;
esac
