#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?usage: fetch-wisp.sh <latest|vX.Y.Z> <destination>}"
DEST="${2:?usage: fetch-wisp.sh <latest|vX.Y.Z> <destination>}"

if [ "$VERSION" = "latest" ]; then
    VERSION=$(curl -fsSL https://api.github.com/repos/LeoLTM/wisp/releases/latest \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')
fi

mkdir -p "$DEST"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

URL="https://github.com/LeoLTM/wisp/releases/download/${VERSION}/wisp-linux-armv6-release.tar.gz"
echo "Fetching wisp ${VERSION}..."
curl -fsSL --retry 3 --retry-delay 5 "$URL" -o "$TMP/wisp.tar.gz"
tar -xzf "$TMP/wisp.tar.gz" -C "$TMP"

test -f "$TMP/wispd"
test -f "$TMP/wispd.service"
file "$TMP/wispd" | grep -q 'ARM'

install -m 755 "$TMP/wispd" "$DEST/wispd"
install -m 644 "$TMP/wispd.service" "$DEST/wispd.service"
echo "$VERSION" > "$DEST/.wisp-version"
echo "Installed wisp ${VERSION} into $DEST"
