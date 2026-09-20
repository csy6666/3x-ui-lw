#!/bin/sh
set -eu

mkdir -p "${XUI_DB_FOLDER:-/etc/x-ui}" "${XUI_LOG_FOLDER:-/var/log/x-ui}"
exec /app/x-ui
