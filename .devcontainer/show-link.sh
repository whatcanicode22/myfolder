#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID پیدا نشد."; exit 1; fi
SNI="${CODESPACE_NAME}-443.app.github.dev"

# Direct link using Codespace domain (SSL is handled by GitHub, and client must initiate TLS handshake)
DIRECT_LINK="vless://${UUID}@${SNI}:443?encryption=none&security=tls&sni=${SNI}&host=${SNI}&fp=chrome&allowInsecure=1&type=ws&path=%2Fgraphql#quiet-net-direct"

# SNI Proxy link (using Hetzner proxy or custom clean IP)
PROXY_IP="94.130.50.12"
PROXY_LINK="vless://${UUID}@${PROXY_IP}:443?encryption=none&security=tls&sni=${SNI}&host=${SNI}&fp=chrome&allowInsecure=1&type=ws&path=%2Fgraphql#quiet-net-proxy"

echo ""
echo "=========================================================================="
echo "  [g2ray] اطلاعات اتصال شما آماده است:"
echo "=========================================================================="
echo ""
echo "🔹 لینک مستقیم (با استفاده از دامنه Codespace - اگر دامنه فیلتر نباشد کار می‌کند):"
echo "👉 $DIRECT_LINK"
echo ""
echo "🔹 لینک با آی‌پی کمکی / پروکسی SNI (اگر آی‌پی زیر سالم باشد کار می‌کند):"
echo "👉 $PROXY_LINK"
echo ""
echo "💡 نکته عیب‌یابی: اگر آی‌پی $PROXY_IP کار نمی‌کند، می‌توانید آن را در نرم‌افزار خود"
echo "   (مانند v2rayNG یا Hiddify) با یک آی‌پی تمیز یا پروکسی SNI دیگر جایگزین کنید."
echo "=========================================================================="
echo ""