#!/bin/bash
# GitHub 推送后自动通知脚本

COMMIT_MSG="$1"
FILES_CHANGED="$2"

# 推送到钉钉
node /root/.openclaw/workspace/push-dingtalk.js \
  "🚀 GitHub 更新" \
  "提交: $COMMIT_MSG | 文件: $FILES_CHANGED" \
  "https://fxg0110.github.io/home/"

echo "✅ 钉钉通知已发送"
