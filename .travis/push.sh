#!/bin/bash

set -e

B="buildah"
if ! command -v buildah; then
    echo "buildah not found, trying docker..."
    if command -v docker; then
        B="docker"
    else
        echo "docker not found, then this won't work..."
        exit 1
    fi
fi

MANIFEST_TOOL_VERSION='v0.9.0'
curl -sSfL https://github.com/estesp/manifest-tool/releases/download/$MANIFEST_TOOL_VERSION/manifest-tool-linux-amd64 \
    -o manifest-tool
chmod +x ./manifest-tool

manifest_push() {
    local version=$2
    local ref=$1:$version

    $B push $ref-amd64
    $B push $ref-armv7hf

    # process and push spec
    sed -e "s|%%VERSION%%|$version|g" spec.template.yml > spec.yml
    ./manifest-tool push from-spec ./spec.yml
    rm spec.yml
}

echo "$DOCKER_PASSWORD" | $B login -u "$DOCKER_USERNAME" --password-stdin

BASE=docker.io/$DOCKER_USERNAME/caddy
# push versioned img
manifest_push $BASE $CADDY_VERSION

# tag/push latest img
$B tag $BASE:$CADDY_VERSION-amd64 $BASE:latest-amd64
$B tag $BASE:$CADDY_VERSION-armv7hf $BASE:latest-armv7hf
manifest_push $BASE latest
