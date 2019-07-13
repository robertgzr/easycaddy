# [easycaddy](https://hub.docker.com/r/robertgzr/caddy)

[![Travis](https://travis-ci.org/robertgzr/docker-caddy.svg?branch=master)](https://travis-ci.org/robertgzr/docker-caddy) [![Microbadger](https://images.microbadger.com/badges/image/robertgzr/caddy.svg)](https://microbadger.com/images/robertgzr/caddy "Get your own image badge on microbadger.com")

multi-arch image* supporting:

* x86_64
* armv7
* arm64

includes the following plugins:

* "github.com/caddyserver/dnsproviders/cloudflare"
* "github.com/caddyserver/forwardproxy"
* "github.com/captncraig/cors"
* "github.com/dhaavi/caddy-permission"
* "github.com/emersion/caddy-wkd"
* "github.com/epicagency/caddy-expires"
* "github.com/hacdias/caddy-minify"
* "github.com/jung-kurt/caddy-cgi"
* "github.com/miekg/caddy-prometheus"
* "github.com/nicolasazrak/caddy-cache"
* "github.com/techknowlogick/caddy-s3browser"
* "github.com/zikes/gopkg"

to add more simply import them [here](src/main.go)

## usage

Use the included config / browse-templates or BYO

```
$ podman run \
    -v /path/to/template/dir:/share/caddy/templates:ro \
    -v /path/to/config/dir:/etc/caddy:ro \
    -dt \
    docker.io/robertgzr/caddy \
    -agree -conf /etc/caddy/Caddyfile
```


Use podman's `container runlabel` command to run commands embedded in the image

```
$ podman container runlabel --display srv docker.io/robertgzr/caddy
command: podman run --name caddy -p 2015:2015 -v .:/var/www:ro -dt docker.io/robertgzr/caddy -conf /etc/caddy/browse.conf
$ podman container runlabel srv docker.io/robertgzr/caddy
Activating privacy features... done.

Serving HTTP on port 2015
http://:2015
```


---

\* thanks to [manifest-tool](https://github.com/estesp/manifest-tool)
