#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION="${1:-latest}"
BUILD="$ROOT/.build"
PIGEN="$BUILD/pi-gen"

command -v docker >/dev/null || { echo "Docker is required."; exit 1; }
command -v git >/dev/null || { echo "git is required."; exit 1; }

mkdir -p "$BUILD"
if [ ! -d "$PIGEN/.git" ]; then
    git clone --depth 1 --branch bookworm https://github.com/RPi-Distro/pi-gen.git "$PIGEN"
fi

cp "$ROOT/config" "$PIGEN/config"
rm -f "$PIGEN/stage2/EXPORT_IMAGE"
rm -rf "$PIGEN/stage-wisp"
cp -a "$ROOT/stage-wisp" "$PIGEN/stage-wisp"

"$ROOT/scripts/fetch-wisp.sh" "$VERSION" "$PIGEN/stage-wisp/00-install/files"

cd "$PIGEN"
sudo ./build-docker.sh

echo
echo "Image(s):"
find "$PIGEN/deploy" -maxdepth 1 -type f -printf '  %p\n'
