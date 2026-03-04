---
name: github-publisher
description: "GitHub 自动化推送与验证系统 v2.0 | 全流程自动化 | UAT巡检 | 钉钉反馈 | 失败降级"
author: OpenClaw
metadata:
  openclaw:
    emoji: 🚀
    requires:
      bins: [git, curl]
---

# GitHub Publisher v2.0

全流程自动化的 GitHub 发布系统，从文件检查到 UAT 验证，全程无需人工干预。

## 核心特性

- ✅ **发布前自动检查** - 验证文件状态、Git仓库
- 💾 **自动提交推送** - Git add → commit → push 一键完成
- 🔍 **UAT自动巡检** - 30s × 10次循环检测，直到HTTP 200
- 📱 **结果自动反馈** - 成功/失败都推送钉钉通知
- 📝 **失败自动降级** - 失败时写入 todo.md，心跳时重试

## 使用方式

```bash
# 进入仓库目录，一键发布
cd /path/to/repo
./publish-v2.sh

# 指定文件模式
./publish-v2.sh . "*.html"
```

## 发布流程

```
┌─────────────────────────────────────────┐
│  1. 发布前检查                            │
│     ├── 验证Git仓库                       │
│     ├── 检查文件变更                      │
│     └── 匹配文件模式                      │
│           ↓ 失败: 钉钉通知跳过原因          │
├─────────────────────────────────────────┤
│  2. Git提交推送                           │
│     ├── git add                          │
│     ├── git commit                       │
│     └── git push                         │
│           ↓ 失败: 钉钉通知+写入todo        │
├─────────────────────────────────────────┤
│  3. UAT自动巡检 (30s × 10次)              │
│     ├── 获取Pages URL                     │
│     ├── 循环检测HTTP 200                  │
│     └── 最多等待5分钟                     │
│           ↓ 失败: 钉钉通知+写入todo        │
├─────────────────────────────────────────┤
│  4. 成功反馈                              │
│     └── 钉钉推送成功消息+报告地址          │
└─────────────────────────────────────────┘
```

## 钉钉通知示例

**成功时**:
```
✅ 发布成功

Git推送成功，UAT验证通过

📄 报告地址:
https://fxg0110.github.io/home/skill-reports/

⏰ 总耗时: 约2分钟
```

**失败时**:
```
❌ 发布失败

Git推送失败，已记录到待办

可能原因:
- 网络问题
- 权限不足
- 仓库冲突

下次心跳将自动重试
```

**UAT失败时**:
```
⚠️ 发布部分成功

Git推送成功，但UAT验证失败

可能原因:
- GitHub Pages缓存延迟
- 文件路径错误
- 仓库设置问题

已记录到待办，将自动重试
```

## 环境变量

```bash
# 钉钉Webhook（必需）
export DINGTALK_WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=xxx"

# 待办文件路径（可选，默认）
export TODO_FILE="/root/.openclaw/workspace/todo.md"
```

## 文件结构

```
github-publisher/
├── SKILL.md                      # 本文件
├── scripts/
│   ├── publish-v2.sh            # 主发布脚本 ⭐
│   ├── verify-pages.sh          # UAT验证脚本
│   └── publish.sh               # 旧版脚本
└── config/
    └── publisher.conf           # 配置文件
```

## 与旧版区别

| 特性 | v1.0 | v2.0 |
|-----|------|------|
| 人工干预 | 需要 | 无需 |
| UAT反馈 | 无 | 钉钉推送 |
| 失败处理 | 手动 | 自动降级到todo |
| 巡检结果 | 仅日志 | 钉钉通知 |
| 全流程 | 半自动 | 全自动 |
