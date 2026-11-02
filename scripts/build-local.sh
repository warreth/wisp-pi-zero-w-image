#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION="${1:-latest}"
BUILD="$ROOT/.build"
PIGEN="$BUILD/pi-gen"
PIGEN_COMMIT="${PIGEN_COMMIT:-1c2abf50924d5bfee3527657af74ddfb1da52904}"

command -v docker >/dev/null || { echo "Docker is required."; exit 1; }
command -v git >/dev/null || { echo "git is required."; exit 1; }
command -v qemu-arm-static >/dev/null || {
    echo "qemu-arm-static is required (install qemu-user-static)."
    exit 1
}
command -v readelf >/dev/null || { echo "readelf is required (install binutils)."; exit 1; }

mkdir -p "$BUILD"
if [ ! -d "$PIGEN/.git" ]; then
    git clone --branch bookworm https://github.com/RPi-Distro/pi-gen.git "$PIGEN"
fi
git -C "$PIGEN" checkout "$PIGEN_COMMIT"

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
