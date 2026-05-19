#!/bin/bash
# g2ray start script — keepalive: 300s
tmux kill-session -t g2ray 2>/dev/null || true
tmux new-session -d -s g2ray
tmux send-keys -t g2ray "sudo /usr/local/bin/xray run -c /etc/xray/g2ray.json &>/tmp/xray.log" Enter
sleep 2
show-link.sh

# Keepalive — ping every 300 seconds to prevent idle shutdown
tmux new-window -t g2ray -n keepalive
tmux send-keys -t g2ray:keepalive "while true; do curl -s --max-time 5 https://github.com/ -o /dev/null; sleep 300; done" Enter
echo "[g2ray] Keepalive فعال است — هر 300 ثانیه یک بار ping"
echo "[g2ray] سرور داخل tmux اجرا شد"
echo "[g2ray] برای دیدن log: tmux attach -t g2ray"