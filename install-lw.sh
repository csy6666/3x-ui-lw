#!/bin/sh
set -eu

REPO="${XUI_LW_REPO:-csy6666/3x-ui-lw}"
VERSION="${XUI_LW_VERSION:-latest}"
INSTALL_DIR="${XUI_LW_INSTALL_DIR:-/opt/3x-ui-lw}"
DB_DIR="${XUI_LW_DB_DIR:-/etc/x-ui}"
LOG_DIR="${XUI_LW_LOG_DIR:-/var/log/x-ui}"

die() { echo "3x-ui-lw: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "run this installer as root"

if [ -f /etc/alpine-release ]; then
  DISTRO=alpine
elif [ -f /etc/debian_version ] && command -v apt-get >/dev/null 2>&1; then
  DISTRO=debian
else
  die "unsupported distribution (supported: Alpine, Debian, Ubuntu)"
fi

case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) die "unsupported architecture: $(uname -m) (supported: amd64, arm64)" ;;
esac

case "$DISTRO" in
  alpine)
    apk add --no-cache ca-certificates curl tar openrc >/dev/null
    ;;
  debian)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y -qq ca-certificates curl tar >/dev/null
    ;;
esac

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

write_env() {
  env_file="$1"
  prefix=""
  [ "$DISTRO" = alpine ] && prefix="export "
  cat > "$env_file" <<EOF
${prefix}XUI_MAIN_FOLDER="$INSTALL_DIR"
${prefix}XUI_BIN_FOLDER="$INSTALL_DIR/bin"
${prefix}XUI_DB_FOLDER="$DB_DIR"
${prefix}XUI_LOG_FOLDER="$LOG_DIR"
${prefix}XUI_PROFILE="lw"
${prefix}XUI_IN_DOCKER="false"
${prefix}XUI_ENABLE_FAIL2BAN="false"
${prefix}XUI_DB_TYPE="sqlite"
${prefix}XUI_MEMORY_LIMIT="96"
${prefix}XUI_GOGC="50"
${prefix}XUI_MEMORY_RELEASE_INTERVAL="5"
EOF
  chmod 0644 "$env_file"
}

case "$DISTRO" in
  alpine)
    write_env /etc/conf.d/x-ui-lw
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
    ;;
  debian)
    command -v systemctl >/dev/null 2>&1 || die "systemd is required for native Debian/Ubuntu installation"
    write_env /etc/default/x-ui-lw
    cat > /etc/systemd/system/x-ui-lw.service <<EOF
[Unit]
Description=3x-ui lightweight proxy panel
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=/etc/default/x-ui-lw
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/x-ui
ExecReload=/bin/kill -USR1 \$MAINPID
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable --now x-ui-lw.service
    ;;
esac

echo "3x-ui-lw installed."
echo "Panel data: ${DB_DIR}"
echo "Panel logs: ${LOG_DIR}"
if [ "$DISTRO" = alpine ]; then
  echo "Service: rc-service x-ui-lw {start|stop|restart|status}"
else
  echo "Service: systemctl {start|stop|restart|status} x-ui-lw"
fi
