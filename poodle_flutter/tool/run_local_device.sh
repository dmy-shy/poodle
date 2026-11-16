#!/usr/bin/env bash
# Launches a debug build against the Serverpod instance running on this Mac.
#
# Usage:
#   ./tool/run_local_device.sh <flutter-device-id>
#
# Android emulators reach the host through 10.0.2.2. Physical devices use the
# active Wi-Fi address, which is discovered each time so DHCP changes are safe.
set -euo pipefail

device_id="${1:?Usage: ./tool/run_local_device.sh <flutter-device-id>}"

if [[ "$device_id" == emulator-* ]]; then
  server_host='10.0.2.2'
else
  server_host="$(ipconfig getifaddr en0 2>/dev/null || true)"
  if [[ -z "$server_host" ]]; then
    server_host="$(ipconfig getifaddr en1 2>/dev/null || true)"
  fi
  if [[ -z "$server_host" ]]; then
    echo 'Could not find a Wi-Fi address. Connect this Mac to Wi-Fi first.' >&2
    exit 1
  fi
fi

exec flutter run -d "$device_id" \
  --dart-define="SERVER_URL=http://${server_host}:8080/" \
  --dart-define='ALLOW_INSECURE_DEVELOPMENT_SERVER=true'
