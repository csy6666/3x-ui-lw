#!/bin/sh
set -eu

REPO="${XUI_LW_REPO:-csy6666/3x-ui-lw}"
VERSION="${XUI_LW_VERSION:-latest}"
INSTALL_DIR="${XUI_LW_INSTALL_DIR:-/opt/3x-ui-lw}"
DB_DIR="${XUI_LW_DB_DIR:-/etc/x-ui}"
LOG_DIR="${XUI_LW_LOG_DIR:-/var/log/x-ui}"

die() { echo "3x-ui-lw: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "run this installer as root"
[ -f /etc/alpine-release ] || die "this installer targets Alpine Linux"

case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) die "unsupported architecture: $(uname -m) (supported: amd64, arm64)" ;;
esac

apk add --no-cache ca-certificates curl tar openrc >/dev/null

if [ "$VERSION" = "latest" ]; then
  base="https://github.com/${REPO}/releases/latest/download"
else
  base="https://github.com/${REPO}/releases/download/${VERSION}"
fi
asset="3x-ui-lw-linux-${ARCH}.tar.gz"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM

echo "Downloading ${REPO} ${VERSION} (${ARCH})..."
curl -fsSL --retry 5 "${base}/${asset}" -o "${tmp}/${asset}"
curl -fsSL --retry 5 "${base}/${asset}.sha256" -o "${tmp}/${asset}.sha256"
(cd "$tmp" && sha256sum -c "${asset}.sha256")

tar -xzf "${tmp}/${asset}" -C "$tmp"
[ -x "${tmp}/x-ui/x-ui" ] || die "release archive does not contain x-ui"
[ -x "${tmp}/x-ui/bin/xray-linux-${ARCH}" ] || die "release archive does not contain Xray for ${ARCH}"

mkdir -p "$INSTALL_DIR" "$DB_DIR" "$LOG_DIR"
cp -a "${tmp}/x-ui/." "$INSTALL_DIR/"
chmod 0755 "$INSTALL_DIR/x-ui" "$INSTALL_DIR/bin/xray-linux-${ARCH}"

umask 022
cat > /etc/conf.d/x-ui-lw <<EOF
export XUI_MAIN_FOLDER="$INSTALL_DIR"
export XUI_BIN_FOLDER="$INSTALL_DIR/bin"
export XUI_DB_FOLDER="$DB_DIR"
export XUI_LOG_FOLDER="$LOG_DIR"
export XUI_PROFILE="lw"
export XUI_IN_DOCKER="false"
export XUI_ENABLE_FAIL2BAN="false"
export XUI_DB_TYPE="sqlite"
export XUI_MEMORY_LIMIT="96"
export XUI_GOGC="50"
export XUI_MEMORY_RELEASE_INTERVAL="5"
EOF

cat > /etc/init.d/x-ui-lw <<'EOF'
#!/sbin/openrc-run

name="3x-ui-lw"
description="3x-ui lightweight proxy panel"
command="${XUI_MAIN_FOLDER:-/opt/3x-ui-lw}/x-ui"
command_background="yes"
pidfile="/run/${RC_SVCNAME}.pid"

depend() {
  need net
  after firewall
}
EOF
chmod 0755 /etc/init.d/x-ui-lw

rc-update add x-ui-lw default >/dev/null 2>&1 || true
if rc-service x-ui-lw status >/dev/null 2>&1; then
  rc-service x-ui-lw restart
else
  rc-service x-ui-lw start
fi

echo "3x-ui-lw installed."
echo "Panel data: ${DB_DIR}"
echo "Panel logs: ${LOG_DIR}"
echo "Service: rc-service x-ui-lw {start|stop|restart|status}"
