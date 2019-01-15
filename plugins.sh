#!/bin/sh
# using the `goimport` tool one can install additional caddy plugins

set -e

plugs="github.com/emersion/caddy-wkd"
plugs="$plugs github.com/caddyserver/forwardproxy"
plugs="$plugs github.com/caddyserver/dnsproviders/cloudflare"
plugs="$plugs github.com/techknowlogick/caddy-s3browser"
plugs="$plugs github.com/hacdias/caddy-minify"
plugs="$plugs github.com/abiosoft/caddy-git"
plugs="$plugs github.com/zikes/gopkg"
plugs="$plugs github.com/captncraig/cors"
plugs="$plugs github.com/nicolasazrak/caddy-cache"
plugs="$plugs github.com/jung-kurt/caddy-cgi"

set -x

for p in $plugs; do
    goimport -w -get -add $p:_ run.go
done
