# syntax=docker/dockerfile:1.1-experimental
# vim: ft=dockerfile

ARG VERSION=0.0.0+unknown

# cross-compile helper
FROM --platform=$BUILDPLATFORM tonistiigi/xx:golang AS xgo

FROM --platform=$BUILDPLATFORM docker.io/library/golang:alpine AS build
COPY --from=xgo / /
ARG TARGETPLATFORM

# get dependencies
RUN apk add -U --no-cache \
        ca-certificates file git

WORKDIR /go/src
# static build
# https://github.com/golang/go/issues/26492
RUN --mount=target=/go/src,source=src,rw \
    --mount=target=/go/pkg,type=cache \
    --mount=target=/root/.cache,type=cache \
    CGO_ENABLED=0 go build \
        -ldflags '-w -extldflags -static' \
        -tags 'cgo netgo static_build osusergo' \
        -o /out/caddy && \
    file /out/caddy | grep "statically linked"

# use this with buildkit:
# $ docker build -o . --target=final .
FROM build AS releaser
ARG TARGETPLATFORM
ARG VERSION
RUN mv /out/caddy /out/caddy-$VERSION-$(echo $TARGETPLATFORM | sed 's/\//-/g')

FROM scratch AS final
COPY --from=releaser /out/ /

# FROM scratch AS run-base-scratch
# FROM alpine:latest AS run-base-alpine
# ARG RUN_BASE=scratch
# FROM run-base-$RUN_BASE AS run
FROM scratch AS run

ARG VERSION
ARG BUILD_DATE
ARG MAINTAINER="robertgzr <r@gnzler.io>"
ARG VCS_URL="https://git.sr.ht/~robertgzr/easycaddy"
LABEL \
    maintainer=$MAINTAINER \
    RUN="podman run --name caddy -p 80:2015 -v .:/var/www:ro -dt IMAGE" \
    SRV="podman run --name caddy -p 2015:2015 -v .:/var/www:ro -dt IMAGE -conf /etc/caddy/browse.conf" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.authors=$MAINTAINER \
    org.opencontainers.image.source=$VCS_URL \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.title="easycaddy" \
    org.opencontainers.image.description="multi-platform, small caddyserver container that supports many plugins out of the box"

COPY --from=build /out/caddy /bin/caddy
COPY conf/* /etc/
COPY templates/ /share/templates/

# add certs from build to enable HTTPS
COPY --from=build \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs/ca-certificates.crt

ENV HOME=/run

EXPOSE 2015
WORKDIR /var/www
ENTRYPOINT ["/bin/caddy"]
CMD ["run", "--conf", "/etc/caddy.conf"]
