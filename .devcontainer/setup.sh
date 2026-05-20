#!/bin/sh
set -e

# Dynamically fetch the latest release version of XTLS/Xray-core
echo "[g2ray] Fetching latest Xray version..."
LATEST_TAG=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | grep -o '"tag_name": *"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v26.5.9"
    echo "[g2ray] Failed to fetch latest tag, falling back to $LATEST_TAG"
else
    echo "[g2ray] Latest Xray version found: $LATEST_TAG"
fi

# Clean version for the URL (removing potential leading 'v' if needed, though XTLS releases use 'v' prefix)
RELEASE="https://github.com/XTLS/Xray-core/releases/download/${LATEST_TAG}/Xray-linux-64.zip"

TMPDIR="$(mktemp -d)"
echo "[g2ray] Downloading Xray ${LATEST_TAG}..."
curl -sL "$RELEASE" -o "$TMPDIR/xray.zip"
unzip -q "$TMPDIR/xray.zip" -d "$TMPDIR"
install -m 755 "$TMPDIR/xray" /usr/local/bin/xray
echo "[g2ray] Downloading GeoIP and GeoSite..."
curl -sL "https://github.com/v2fly/geoip/releases/latest/download/geoip.dat" -o /usr/local/bin/geoip.dat
curl -sL "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat" -o /usr/local/bin/geosite.dat
rm -rf "$TMPDIR"
echo "[g2ray] Done."