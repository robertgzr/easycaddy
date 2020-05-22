# [easycaddy](https://hub.docker.com/r/robertgzr/caddy)

[![builds.sr.ht status](https://builds.sr.ht/~robertgzr/easycaddy/.build.yml.svg)](https://builds.sr.ht/~robertgzr/easycaddy/.build.yml?) [![Travis](https://img.shields.io/travis/robertgzr/docker-caddy/master.svg?label=travis)](https://travis-ci.org/robertgzr/docker-caddy.svg?branch=master) [![Microbadger](https://images.microbadger.com/badges/image/robertgzr/caddy.svg)](https://microbadger.com/images/robertgzr/caddy "Get your own image badge on microbadger.com")

multi-arch image* supporting:

* x86_64
* armv7
* arm64

includes the following plugins:

* github.com/hairyhenderson/caddyprom
* ~~github.com/caddyserver/dnsproviders/cloudflare~~
* ~~github.com/caddyserver/forwardproxy~~
* ~~github.com/captncraig/cors~~
* ~~github.com/dhaavi/caddy-permission~~
* ~~github.com/emersion/caddy-wkd~~
* ~~github.com/epicagency/caddy-expires~~
* ~~github.com/hacdias/caddy-minify~~
* ~~github.com/jung-kurt/caddy-cgi~~
* ~~github.com/miekg/caddy-prometheus~~
* ~~github.com/nicolasazrak/caddy-cache~~
* ~~github.com/pyed/ipfilter~~
* ~~github.com/techknowlogick/caddy-s3browser~~
* ~~github.com/xuqingfeng/caddy-rate-limit~~
* ~~github.com/zikes/gopkg~~

_will have to see what still works under caddy v2_

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
$ podman container runlabel srv docker.io/robertgzr/caddy
Activating privacy features... done.

Serving HTTP on port 2015
http://:2015
```

## building

after modifying the target binary by editing [src/main.go](src/main.go), run the following commands:

```
$ REPO=you/my_caddy ./make.sh build <amd64|aarch64|armv7hf>  # to build the container
```

---

\* thanks to [buildkit](https://github.com/moby/buildkit)
