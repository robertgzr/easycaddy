#!/bin/sh

set -e
[ -n "$DEBUG" ] && set -x

REPO=${REPO:-"docker.io/robertgzr/caddy"}
ARCHS=${ARCHS:-"amd64 armv7hf aarch64"}
VERSION=${VERSION:-"v1.0.1"}
DOCKERFILE=${DOCKERFILE:-"Dockerfile"}
BUILD=${BUILD:-"buildah bud"}
PUSH=${PUSH:-"buildah push"}
OS=${OS:-"linux"}

_info() {
    echo -e "\033[1;34m" "> $1" "\033[0m"
}
_do() {
    echo $@
    [ -n "$DRY" ] && return
    eval $@
}

_build() {
    arch="$1"
    tag="${REPO}:${VERSION}-${arch}"
    build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    _info "building container image for ${arch}"
    _do ${BUILD} \
	--file=${DOCKERFILE} \
	--tag=${tag} \
	--build-arg BUILD_DATE=${build_date} \
	--build-arg VERSION=${VERSION} \
	--build-arg GOOS=${GOOS} \
	--build-arg GOARCH=${GOARCH} \
	--build-arg GOARM=${GOARM} \
	.
}

_check_and_download_manifest_tool() {
    mt_url="https://github.com/estesp/manifest-tool/releases/download/v0.9.0/manifest-tool-linux-amd64"
    _info "checking if manifest-tool is available"
    _do which manifest-tool && return
    _info "installing manifest-tool"
    _do curl -sSfL "${mt_url}" -o ./manifest-tool
    _do chmod u+x ./manifest-tool
}

_push() {
    arch="$1"
    tag="${REPO}:${VERSION}-${arch}"
    _info "pushing container image for ${arch}"
    _do ${PUSH} ${tag}
}

while test $# -gt 0; do
    case "$1" in
	build)
	    export GOOS=${OS}
	    for arch in ${2:-$ARCHS}; do
		unset GOARCH; unset GOARM;
		case "$arch" in
		    amd64)   export GOARCH="amd64" ;;
		    armv7hf) export GOARCH="arm"; export GOARM="7" ;;
		    aarch64) export GOARCH="arm64" ;;
		    *) 	echo "not one of: $ARCHS"
			exit 1 ;;
		esac
		_build $arch
	    done
	    ;;

	push)
	    _check_and_download_manifest_tool
	    for arch in ${2:-$ARCHS}; do
		_push $arch
	    done
	    _info "pushing manifest"
	    trap '{ rm -f spec.yml; }' EXIT
	    sed \
		    -e "s|{%VERSION%}|${VERSION}|g" \
		    -e "s|{%REPO%}|${REPO}|g" \
		    spec.template.yml > spec.yml
	    _do ./manifest-tool push from-spec ./spec.yml
	    ;;

	webhook)
	    _info "triggering microbadger refresh"
	    _do curl -X POST ${MB_WEBHOOK}
	    ;;
    esac
    shift
done
