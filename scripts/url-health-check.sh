#!/bin/bash
# GitHub Pages 可访问性巡检脚本
# 由心跳任务调用

CHECKLIST_FILE="/root/.openclaw/workspace/github-pages/docs/url-checklist.md"
LOG_FILE="/root/.openclaw/workspace/github-pages/url-check.log"
FAILED_URLS=""

echo "========================================" >> "$LOG_FILE"
echo "巡检开始: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

# 从清单文件提取 URL
grep -E "^\- https://" "$CHECKLIST_FILE" | sed 's/^- //' | while read -r url; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ $url" >> "$LOG_FILE"
    else
        echo "❌ $url (HTTP $HTTP_CODE)" >> "$LOG_FILE"
        FAILED_URLS="$FAILED_URLS\n$url (HTTP $HTTP_CODE)"
    fi
    
    # 避免请求过快
    sleep 1
done

echo "" >> "$LOG_FILE"
echo "巡检完成: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 如果有失败的 URL，发送告警
if [ -n "$FAILED_URLS" ]; then
    echo "发现可访问性异常:"
    echo -e "$FAILED_URLS"
    exit 1
else
    echo "所有 URL 可访问性正常"
    exit 0
fi
