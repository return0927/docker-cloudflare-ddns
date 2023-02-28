# Cloudflare DDNS

## Usage
1. Run in raw
```sh
$ INTERVAL=10s DOMAIN=test.enak.kr TOKEN=CLOUDFLARE_TOKEN_HERE ZONE_ID=CLOUDFLARE_ZONE_ID_HERE ./update-ip.sh
```

2. Run in Docker
```sh
$ docker run \
    --name cloudflare-ddns \
    -e INTERVAL=10s \
    -e DOMAIN=test.enak.kr \
    -e TOKEN=CLOUDFLARE_TOKEN_HERE \
    -e ZONE_ID=CLOUDFLARE_ZONE_ID_HERE \
    --detach \
    ghcr.io/return0927/cloudflare-ddns
```
