# vim: ft=dockerfile
FROM docker.io/library/golang:1.12-alpine as build

ARG GOOS
ARG GOARCH
ARG GOARM

# get dependencies
RUN apk add ca-certificates git

COPY ./src /go/src

# set go toolchain env
ENV \
    GOOS=$GOOS \
    GOARCH=$GOARCH \
    GOARM=$GOARM \
    CGO_ENABLED=0 \
    GO111MODULE=on

WORKDIR /go/src
# static build
# https://github.com/golang/go/issues/26492
RUN set -e;\
    go mod download; \
    find /go/pkg/mod -name '*.go' | while read -r f; do \
            sed -i -e 's|github.com/mholt/caddy|github.com/caddyserver/caddy|g' $f; \
    done; \
    go build -a \
    -ldflags '-extldflags "-fno-PIC -static"' \
    -tags "osusergo netgo static_build" \
    -o /out/caddy .

# put binary and certs into scratch container
FROM scratch
# or alpine
# FROM alpine:3.10

ARG BUILD_DATE
ARG VERSION

LABEL \
    maintainer="robertgzr <r@gnzler.io>" \
    RUN="podman run --name caddy -p 80:2015 -v .:/var/www:ro -dt IMAGE" \
    SRV="podman run --name caddy -p 2015:2015 -v .:/var/www:ro -dt IMAGE -conf /etc/caddy/browse.conf" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.version=$VERSION \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/robertgzr/docker-caddy"

COPY --from=build /out/caddy /usr/bin/caddy
COPY conf /etc/caddy
COPY templates /share/caddy/templates

# add certs from build to enable HTTPS
COPY --from=build \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs/ca-certificates.crt

EXPOSE 2015
WORKDIR /var/www
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "-conf", "/etc/caddy/caddy.conf"]
