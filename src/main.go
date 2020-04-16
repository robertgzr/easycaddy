package main // import "git.sr.ht/~robertgzr/easycaddy"

import (
	caddycmd "github.com/caddyserver/caddy/v2/cmd"

	_ "github.com/caddyserver/caddy/v2/modules/standard"

	// _ "github.com/caddyserver/dnsproviders/cloudflare"
	// _ "github.com/caddyserver/forwardproxy"
	// _ "github.com/captncraig/cors"
	// _ "github.com/dhaavi/caddy-permission"
	// _ "github.com/emersion/caddy-wkd"
	// _ "github.com/epicagency/caddy-expires"
	// _ "github.com/hacdias/caddy-minify"
	// _ "github.com/jung-kurt/caddy-cgi"
	// _ "github.com/miekg/caddy-prometheus"
	// _ "github.com/nicolasazrak/caddy-cache"
	// _ "github.com/pyed/ipfilter"
	// _ "github.com/techknowlogick/caddy-s3browser"
	// _ "github.com/xuqingfeng/caddy-rate-limit"
	// _ "github.com/zikes/gopkg"
)

func main() {
	caddycmd.Main()
}
