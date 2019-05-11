#!/bin/sh
# using the `goimport` tool to install additional caddy plugins

set -e

if ! command -v goimport &>/dev/null; then
    echo "error: goimport not in PATH"
    echo ""
    exit 1
fi

plugs='
github.com/emersion/caddy-wkd
github.com/caddyserver/forwardproxy
github.com/caddyserver/dnsproviders/cloudflare
github.com/techknowlogick/caddy-s3browser
github.com/hacdias/caddy-minify
github.com/abiosoft/caddy-git
github.com/zikes/gopkg
github.com/captncraig/cors
github.com/nicolasazrak/caddy-cache
github.com/epicagency/caddy-expires
github.com/jung-kurt/caddy-cgi
'
# github.com/filebrowser/caddy

flags=
for p in $plugs; do
    flags="$flags -add ${p}:_"
done

set -x
goimport -w $flags run.go
