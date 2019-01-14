FROM library/golang:1.11-alpine as build

RUN apk add --no-cache git \
  && go get -u arp242.net/goimport \
  && go get github.com/mholt/caddy/caddy \
  && go get github.com/caddyserver/builds

# disable telemetry
WORKDIR $GOPATH/src/github.com/mholt/caddy/caddy/caddymain
RUN sed -i 's/var EnableTelemetry.*/var EnableTelemetry = false/' run.go \
  && cat run.go

# using the `goimport` tool one can install additional caddy plugins:
#
# RUN goimport -get -add <import>:_ caddymain/run.go
#
RUN goimport -w -get -add github.com/emersion/caddy-wkd:_ run.go
RUN goimport -w -get -add github.com/caddyserver/forwardproxy:_ run.go
RUN goimport -w -get -add github.com/caddyserver/dnsproviders/cloudflare:_ run.go
RUN goimport -w -get -add github.com/techknowlogick/caddy-s3browser:_ run.go
RUN goimport -w -get -add github.com/hacdias/caddy-minify:_ run.go
RUN goimport -w -get -add github.com/abiosoft/caddy-git:_ run.go
RUN goimport -w -get -add github.com/zikes/gopkg:_ run.go
RUN goimport -w -get -add github.com/captncraig/cors:_ run.go
RUN goimport -w -get -add github.com/nicolasazrak/caddy-cache:_ run.go
RUN goimport -w -get -add github.com/jung-kurt/caddy-cgi:_ run.go

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
