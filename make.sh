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
    which manifest-tool && return
    _info "installing manifest-tool"
    _do curl -sSfL "${mt_url}" -o ./manifest-tool
    chmod u+x ./manifest-tool
}

_push() {
    arch="$1"
    tag_version="${REPO}:${VERSION}-${arch}"
    _info "pushing container image for ${arch}"
    _do ${PUSH} ${tag_version}
    tag_latest="${REPO}:latest-${arch}"
    _do ${PUSH} ${tag_latest}
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
	    for ver in "${VERSION} latest"; do
		_info "pushing manifest for ${ver}"
		trap "{ rm -f spec-${ver}.yml; }" EXIT
		sed \
			-e "s|{%VERSION%}|${ver}|g" \
			-e "s|{%REPO%}|${REPO}|g" \
			spec.template.yml > spec-${ver}.yml
		./manifest-tool --username=${DOCKER_USERNAME} --password=${DOCKER_PASSWORD} push from-spec ./spec-${ver}.yml
	    done
	    ;;

	webhook)
	    _info "triggering microbadger refresh"
	    curl -X POST ${MB_WEBHOOK}
	    ;;
    esac
    shift
done
