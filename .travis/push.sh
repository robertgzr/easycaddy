#!/bin/bash

manifest() {
    docker push $1-amd64
    docker push $1-armv7hf
    docker manifest create --amend $1 $1-amd64 $1-armv7hf
    docker manifest annotate $1 $1-armv7hf --os linux --arch arm --variant armv7
    docker manifest push $1
}

MANIFEST_TOOL_VERSION='v1.0.0-rc'

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

BASE=docker.io/$DOCKER_USERNAME/caddy
# push versioned img
manifest_push $BASE:$CADDY_VERSION

# tag/push latest img
docker tag $BASE:$CADDY_VERSION-amd64 $BASE:latest-amd64
docker tag $BASE:$CADDY_VERSION-armv7hf $BASE:latest-armv7hf
manifest_push $BASE:latest
