module github.com/robertgzr/docker-caddy

go 1.12

require (
	github.com/caddyserver/dnsproviders v0.2.0
	github.com/caddyserver/forwardproxy v0.0.0-20190501063659-7af135a17526
	github.com/captncraig/cors v0.0.0-20190326022215-48080ede89fe
	github.com/emersion/caddy-wkd v0.0.0-20181203212415-029b4baaa9bd
	github.com/emersion/go-openpgp-wkd v0.0.0-20180912215106-a3509d9ba389
	github.com/epicagency/caddy-expires v1.1.0
	github.com/hacdias/caddy-minify v1.0.0
	github.com/jung-kurt/caddy-cgi v1.11.1
	github.com/mholt/caddy v1.0.0
	github.com/nicolasazrak/caddy-cache v0.3.2
	github.com/pquerna/cachecontrol v0.0.0-20180517163645-1555304b9b35
	github.com/techknowlogick/caddy-s3browser v0.0.0-20190511002423-f5b0250763e1
	github.com/zikes/gopkg v1.0.1
)

replace github.com/h2non/gock => gopkg.in/h2non/gock.v1 v1.0.14
