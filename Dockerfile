# vim: ft=dockerfile
FROM library/golang:1.11-alpine as build

RUN apk add --no-cache git \
  && go get -u arp242.net/goimport \
  && go get github.com/mholt/caddy/caddy \
  && go get github.com/caddyserver/builds

# disable telemetry
WORKDIR $GOPATH/src/github.com/mholt/caddy/caddy/caddymain
RUN sed -i 's/var EnableTelemetry.*/var EnableTelemetry = false/' run.go \
  && cat run.go

COPY plugins.sh /
RUN /plugins.sh

# build everything
WORKDIR $GOPATH/src/github.com/mholt/caddy/caddy
RUN go run build.go \
  && mkdir /out \
  && cp caddy /out/caddy

# put the binary into a minimal alpine container
FROM library/alpine

RUN apk add --no-cache --update ca-certificates

COPY --from=build /out/caddy /usr/local/bin/caddy

EXPOSE 80 443 2015
WORKDIR /var/www
ENTRYPOINT ["/usr/local/bin/caddy"]
CMD ["-agree", "-conf", "/var/lib/caddy/Caddyfile"]
