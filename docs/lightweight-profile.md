# 3x-ui-lw lightweight profile

The lightweight profile is intended for small Alpine NAT VPS instances. Enable
it with `XUI_PROFILE=lw` (the `Dockerfile.lw` image enables it by default).

The first profile supports only these VLESS combinations:

- XHTTP + TLS, normally placed behind a CDN or HTTP reverse proxy.
- WebSocket + TLS, normally placed behind a CDN or HTTP reverse proxy.
- TCP + REALITY, normally exposed directly without a CDN proxy.

SQLite is the only database backend in the lightweight image. The image does
not include Fail2ban, PostgreSQL, geoip/geosite data, MTProto, TUIC, or other
protocol sidecars. Those features remain in the normal profile and can be
added in a later profile revision.

The lw frontend route graph omits the node, host and API-doc pages, and the
image build removes their unreachable lazy chunks (including Swagger assets).

The lw runtime also skips remote-node, sidecar, WARP, outbound-refresh and
system-monitor cron jobs. Xray health, traffic accounting, client IP-limit
scanning and periodic traffic resets remain enabled. The image defaults to a
96 MiB Go soft limit, `GOGC=50`, and a five-minute OS-memory release interval;
these are tuning defaults, not a guarantee that an arbitrary workload fits in
120 MiB including Xray and the Alpine kernel cache.

`XUI_PROFILE=lw` is enforced by the backend, so unsupported API payloads are
rejected even if a client bypasses the reduced frontend picker.

## Alpine one-line installation

After a lightweight `lw-v*` release is published, install a prebuilt Alpine
package without compiling on the target VPS:

```sh
curl -fsSL https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/install-lw.sh | sh
```

The installer supports Alpine `amd64` and `arm64`, verifies the SHA-256 file,
stores the SQLite database in `/etc/x-ui`, and registers the `x-ui-lw` OpenRC
service. Set `XUI_LW_VERSION=lw-v0.1.0` to pin a release.

For Docker deployments using the published image:

```sh
mkdir -p /opt/3x-ui-lw && cd /opt/3x-ui-lw
curl -fsSLO https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/docker-compose.lw.yml
docker compose -f docker-compose.lw.yml up -d
```
