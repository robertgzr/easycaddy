#!/bin/sh
# using the `goimport` tool to install additional caddy plugins

set -e

if ! command -v goimport &>/dev/null; then
    echo "error: goimport not in PATH"
    echo ""

    echo $PATH
    ls -l $GOPATH/bin
    exit 1
fi

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
# plugs="$plugs github.com/filebrowser/caddy"

set -x

for p in $plugs; do
    goimport -w -get -add $p:_ run.go
done
