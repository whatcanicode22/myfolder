#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID not found."; exit 1; fi
SNI="${CODESPACE_NAME}-443.app.github.dev"
# Direct link using Codespace domain (SSL is handled by GitHub, and client must initiate TLS handshake)
DIRECT_LINK="vless://${UUID}@${SNI}:443?encryption=none&security=tls&sni=${SNI}&fp=chrome&type=ws&host=${SNI}&path=%2Fapi#quiet-net-direct"

# SNI Proxy link (using Hetzner proxy or custom clean IP)
PROXY_IP="94.130.50.12"
PROXY_LINK="vless://${UUID}@${PROXY_IP}:443?encryption=none&security=tls&sni=${SNI}&fp=chrome&type=ws&host=${SNI}&path=%2Fapi#quiet-net-proxy"
echo ""
echo "=========================================================================="
echo "  [g2ray] Your connection information is ready:"
echo "=========================================================================="
echo ""
echo "🔹 Direct Link (using Codespace domain - works if the domain is not filtered):"
echo "👉 $DIRECT_LINK"
echo ""
echo "🔹 Link with helper IP / SNI Proxy (works if the IP below is clean/functional):"
echo "👉 $PROXY_LINK"
echo ""
echo "💡 Troubleshooting tip: If the IP $PROXY_IP does not work, you can replace it"
echo "   in your client software (e.g. v2rayNG or Hiddify) with a clean IP or another SNI proxy."
echo "=========================================================================="
echo ""