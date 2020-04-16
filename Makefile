DOCKER ?= docker

PLATFORM ?= linux/amd64
VERSION ?= 2.0.0-rc.3
BUILD_DATE ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
REPO ?= docker.io/robertgzr/caddy
TAG ?= $(VERSION)

docker_build = DOCKER_BUILDKIT=1 $(DOCKER) build \
		--platform $(PLATFORM) \
		--file Dockerfile \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg VERSION="$(VERSION)" \
		$(1) \
		.

all: container

.PHONY: ensure-version
ensure-version:
	sed -i 's#^\(github.com/caddyserver/caddy\) v[a-zA-Z0-9\.-_]+$$#\1 v$(VERSION)#' src/go.mod

.PHONY: binary
binary: ensure-version
	$(call docker_build, \
		--target=final \
		--output=.)

.PHONY: container
container: ensure-version
	$(call docker_build, \
		--target run \
		--build-arg RUN_BASE=scratch \
		--tag $(REPO):$(TAG))

MULTIARCH_PLATFORMS = linux/amd64 linux/arm/v7 linux/arm64
.PHONY: container-multiarch
container-multiarch: $(foreach platform,$(MULTIARCH_PLATFORMS),$(platform))
	$(DOCKER) manifest push --purge $(REPO):$(TAG)
	$(DOCKER) manifest inspect $(REPO):$(TAG)

${MULTIARCH_PLATFORMS}: PLATFORM=$@
${MULTIARCH_PLATFORMS}:
	$(call docker_build, \
		--target run \
		--build-arg RUN_BASE=scratch \
		--tag $(REPO):$(TAG)-$(shell ./maparch.sh $(PLATFORM)))
	$(DOCKER) push $(REPO):$(TAG)-$(shell ./maparch.sh $(PLATFORM))
	$(DOCKER) manifest create --amend $(REPO):$(TAG) \
		$(REPO):$(TAG)-$(shell ./maparch.sh $(PLATFORM))
