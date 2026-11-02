#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?usage: fetch-wisp.sh <latest|vX.Y.Z> <destination>}"
DEST="${2:?usage: fetch-wisp.sh <latest|vX.Y.Z> <destination>}"

CURL_OPTS=(-fsSL)
if [ -n "${GH_TOKEN:-}" ]; then
    CURL_OPTS+=(-H "Authorization: Bearer ${GH_TOKEN}")
fi

api() {
    curl "${CURL_OPTS[@]}" "$1"
}

if [ "$VERSION" = "latest" ]; then
    VERSION=$(api https://api.github.com/repos/LeoLTM/wisp/releases/latest \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')
fi

DIGEST=$(api "https://api.github.com/repos/LeoLTM/wisp/releases/tags/${VERSION}" \
    | python3 -c '
import json, sys
release = json.load(sys.stdin)
for asset in release.get("assets", []):
    if asset.get("name") == "wisp-linux-armv6-release.tar.gz":
        print(asset.get("digest") or "")
        break
')
if [ -z "$DIGEST" ]; then
    echo "No SHA256 digest published for wisp ${VERSION}; refusing to build." >&2
    exit 1
fi

mkdir -p "$DEST"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

URL="https://github.com/LeoLTM/wisp/releases/download/${VERSION}/wisp-linux-armv6-release.tar.gz"
echo "Fetching wisp ${VERSION}..."
curl "${CURL_OPTS[@]}" --retry 3 --retry-delay 5 "$URL" -o "$TMP/wisp.tar.gz"
echo "${DIGEST#sha256:}  $TMP/wisp.tar.gz" | sha256sum -c -
tar -xzf "$TMP/wisp.tar.gz" -C "$TMP"

test -f "$TMP/wispd"
test -f "$TMP/wispd.service"
readelf -h "$TMP/wispd" | grep -q 'Machine:.*ARM'
readelf -A "$TMP/wispd" | grep -q 'Tag_CPU_arch: v6'

install -m 755 "$TMP/wispd" "$DEST/wispd"
install -m 644 "$TMP/wispd.service" "$DEST/wispd.service"
echo "$VERSION" > "$DEST/.wisp-version"
echo "Installed wisp ${VERSION} into $DEST"
