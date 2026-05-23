#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID not found."; exit 1; fi
SNI="${CODESPACE_NAME}-443.app.github.dev"
# Direct link using Codespace domain (SSL is handled by GitHub, and client must initiate TLS handshake)
DIRECT_LINK="vless://${UUID}@${SNI}:443?encryption=none&security=tls&sni=${SNI}&fp=chrome&alpn=h2%2Chttp%2F1.1&insecure=1&allowInsecure=1&type=xhttp&host=${SNI}&path=%2Fapi&mode=auto&extra=%7B%22xPaddingBytes%22%3A%221-1%22%2C%22xPaddingObfsMode%22%3Atrue%2C%22xPaddingKey%22%3A%22xtest%22%2C%22xPaddingHeader%22%3A%22XTest%22%2C%22mode%22%3A%22auto%22%2C%22scMaxEachPostBytes%22%3A%221000000%22%2C%22x-host%22%3A%22${SNI}%22%2C%22headers%22%3A%7B%22x-host%22%3A%22${SNI}%22%7D%7D#quiet-net-direct"

# SNI Proxy link (using Hetzner proxy or custom clean IP)
PROXY_IP="94.130.50.12"
PROXY_LINK="vless://${UUID}@${PROXY_IP}:443?encryption=none&security=tls&sni=${SNI}&fp=chrome&alpn=h2%2Chttp%2F1.1&insecure=1&allowInsecure=1&type=xhttp&host=${SNI}&path=%2Fapi&mode=auto&extra=%7B%22xPaddingBytes%22%3A%221-1%22%2C%22xPaddingObfsMode%22%3Atrue%2C%22xPaddingKey%22%3A%22xtest%22%2C%22xPaddingHeader%22%3A%22XTest%22%2C%22mode%22%3A%22auto%22%2C%22scMaxEachPostBytes%22%3A%221000000%22%2C%22x-host%22%3A%22${SNI}%22%2C%22headers%22%3A%7B%22x-host%22%3A%22${SNI}%22%7D%7D#quiet-net-proxy"
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