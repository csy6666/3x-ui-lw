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

`XUI_PROFILE=lw` is enforced by the backend, so unsupported API payloads are
rejected even if a client bypasses the reduced frontend picker.
