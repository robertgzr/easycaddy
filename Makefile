# if you change this, also change the version in src/go.mod
VERSION ?= v1.0.0

all: push

build: build.amd64 build.armv7hf

build.amd64:
	env CADDY_VERSION=$(VERSION) .travis/build.sh amd64

build.armv7hf:
	env CADDY_VERSION=$(VERSION) .travis/build.sh armv7hf

push:
	env CADDY_VERSION=$(VERSION) .travis/push.sh

.PHONY: build build.amd64 build.armv7hf push
