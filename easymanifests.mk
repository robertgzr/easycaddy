REPO       ?= localhost/easymanifest
ARCHS      ?= amd64
BUILD      ?= buildah bud
PUSH       ?= buildah push
DOCKERFILE ?= Dockerfile
VERSION    ?= $(shell git describe --tag --always)
BUILD_DATE ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
OS         ?= linux

arch = $(word 2,$(subst ., ,$1))
tag  = $(subst __arch__,$1,"$(REPO):$(VERSION)-__arch__")

BUILDS = $(addprefix build.,$(ARCHS))
PUSHES = $(addprefix push.,$(ARCHS))

all: push

build: $(BUILDS)
	@echo $<

build.%:
	$(eval ARCH ?= $(call arch,$@))
	$(eval TAG  ?= $(call tag,$(ARCH)))
	$(eval GOOS ?= $(OS))
	$(eval GOARCH ?= $(ARCH))
	@echo "> building container image for $(ARCH)"
	$(BUILD) \
	    --file=$(DOCKERFILE) \
	    --tag=$(TAG) \
	    --build-arg BUILD_DATE=$(BUILD_DATE) \
	    --build-arg VERSION=$(VERSION) \
	    --build-arg GOOS=$(GOOS) \
	    --build-arg GOARCH=$(GOARCH) \
	    --build-arg GOARM=$(GOARM) \
	    .

push.%: build.%
	$(eval ARCH ?= $(call arch,$@))
	$(eval TAG  ?= $(call tag,$(ARCH)))
	@echo "> pushing container image for $(ARCH)"
	$(PUSH) $(TAG)

push: $(PUSHES)
	@echo "> pushing manifest"
	sed \
		-e "s|{%VERSION%}|$(VERSION)|g" \
		-e "s|{%REPO%}|$(REPO)|g" \
		spec.template.yml > spec.yml
	manifest-tool push from-spec ./spec.yml
	rm spec.yml
