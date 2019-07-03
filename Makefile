include easymanifests.mk

REPO  = docker.io/robertgzr/caddy
ARCHS = amd64 armv7hf aarch64
VERSION = v1.0.1

build.armv7hf: pre.armv7hf
pre.armv7:
	$(eval GOARM=7)
build.aarch64: pre.aarch64
pre.aarch64:
	$(eval GOARCH=arm64)

webhook:
	curl -X POST $(MB_WEBHOOK) # trigger mb refresh

