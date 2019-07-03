package main // import "github.com/robertgzr/docker-caddy"

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	_ "github.com/caddyserver/dnsproviders/cloudflare"
	_ "github.com/caddyserver/forwardproxy"
	_ "github.com/captncraig/cors"
	_ "github.com/emersion/caddy-wkd"
	_ "github.com/epicagency/caddy-expires"
	_ "github.com/hacdias/caddy-minify"
	_ "github.com/jung-kurt/caddy-cgi"
	_ "github.com/nicolasazrak/caddy-cache"
	_ "github.com/techknowlogick/caddy-s3browser"
	_ "github.com/zikes/gopkg"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
