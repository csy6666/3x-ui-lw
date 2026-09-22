# 3x-ui-lw lightweight profile

The lightweight profile is intended for small Alpine, Debian, and Ubuntu NAT
VPS instances. Enable it with `XUI_PROFILE=lw` (the `Dockerfile.lw` image
enables it by default).

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

The lw runtime also skips remote-node, sidecar, WARP, outbound-refresh,
fail2ban/IP-limit scanning, and system-monitor cron jobs. Xray health, traffic
accounting, and periodic traffic resets remain enabled. The image defaults to a
64 MiB Go soft limit, `GOGC=25`, a three-minute OS-memory release interval, and
a small SQLite cache with file-backed temporary tables; these are tuning
defaults, not a guarantee that an arbitrary workload fits in 120 MiB including
Xray and the Alpine kernel cache. File-backed temporary tables trade a small
amount of disk I/O for lower transient memory use.

The lightweight build embeds and exposes Simplified Chinese (`zh-CN`) only.
The full distribution keeps the original language set.

`XUI_PROFILE=lw` is enforced by the backend, so unsupported API payloads are
rejected even if a client bypasses the reduced frontend picker.

## Native one-line installation

After a lightweight `lw-v*` release is published, install a prebuilt package
without compiling on the target VPS. The installer detects Alpine, Debian, and
Ubuntu automatically:

```sh
curl -fsSL https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/install-lw.sh | sh
```

The first release supports `amd64` (and the installer is ready for `arm64`
archives when published), verifies the SHA-256 file, and stores the SQLite
database in `/etc/x-ui`. Alpine registers an OpenRC service; Debian and Ubuntu
register a systemd service. Set `XUI_LW_VERSION=lw-v0.1.3` to pin a release.

For an IPv6-only VPS, verify that GitHub is reachable before running the
installer:

```sh
curl -6 -I https://github.com
```

The panel and Xray listeners can use IPv6. When opening the panel directly,
put the address in brackets, for example `http://[2001:db8::1]:2053`.

For Docker deployments using the published image:

```sh
mkdir -p /opt/3x-ui-lw && cd /opt/3x-ui-lw
curl -fsSLO https://raw.githubusercontent.com/csy6666/3x-ui-lw/lw/mvp-protocol-whitelist/docker-compose.lw.yml
docker compose -f docker-compose.lw.yml up -d
```
