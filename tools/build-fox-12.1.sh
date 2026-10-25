#!/bin/bash
# Build OrangeFox (fox_12.1 manifest) for opkona from a fresh sync.
#
#   tools/build-fox-12.1.sh /path/to/fox_12.1 [/path/to/out_dir]
#
# What it does, and why (all found while building this tree on a host with a
# system-wide RBE profile):
#  1. copies this device tree to <fox>/device/oneplus/opkona (a symlink is not
#     found by the product scan);
#  2. applies patches/fox_12.1/*.patch to the matching projects (the sync script
#     does not carry them);
#  3. uses an OUT_DIR *outside* the source tree: with an in-tree OUT_DIR Soong
#     gets a relative $(OUT), runs from /, and silently fails to copy the theme
#     into recovery/root/twres, so the build ends at "sed: .../twres/splash.xml:
#     No such file" and a recovery built that way boots to a black screen;
#  4. turns remote build execution off, so link steps cannot hang on an
#     unreachable RBE service.
set -e
FOX="$(readlink -f "${1:?usage: $0 /path/to/fox_12.1 [out_dir]}")"
OUT="${2:-${FOX}_out}"
DEV="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$FOX/device/oneplus/opkona" "$OUT"
rsync -a --delete --exclude .git --exclude patches --exclude tools "$DEV/" "$FOX/device/oneplus/opkona/"

# patches: <project path with / replaced by _>-<name>.patch
for p in "$DEV"/patches/fox_12.1/*.patch; do
	proj="$(basename "$p")"; proj="${proj%%-*}"; proj="${proj//_//}"
	if git -C "$FOX/$proj" apply --check "$p" 2>/dev/null; then
		git -C "$FOX/$proj" apply "$p" && echo "applied $(basename "$p") to $proj"
	else
		echo "skip $(basename "$p") (already applied or does not apply) in $proj"
	fi
done

cd "$FOX"
export LC_ALL=C
export OUT_DIR="$OUT"
for v in $(env | grep -o '^RBE_[A-Za-z0-9_]*'); do unset "$v"; done
export USE_RBE=false
source build/envsetup.sh
lunch ofox_opkona-eng
mka adbd recoveryimage -j"$(nproc)"
echo "image: $OUT/target/product/opkona/"
