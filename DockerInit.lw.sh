#!/bin/sh
set -eu

case "${1:-amd64}" in
  amd64) ARCH=64; FNAME=amd64 ;;
  arm64|aarch64|armv8) ARCH=arm64-v8a; FNAME=arm64 ;;
  armv7|arm) ARCH=arm32-v7a; FNAME=arm32 ;;
  *) echo "unsupported target architecture: $1" >&2; exit 1 ;;
esac

XRAY_VERSION="${XRAY_VERSION:-v26.9.9}"
mkdir -p build/bin
cd build/bin
curl -fsSL -o xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-${ARCH}.zip"
unzip -q xray.zip xray
rm -f xray.zip
mv xray "xray-linux-${FNAME}"
chmod 0755 "xray-linux-${FNAME}"
