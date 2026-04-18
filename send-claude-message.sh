#!/bin/bash

# 向 tmux 窗口中的 Claude 代理发送消息
# 用法: send-claude-message.sh <会话:窗口> <消息>

if [ $# -lt 2 ]; then
    echo "用法: $0 <会话:窗口> <消息>"
    echo "示例: $0 agentic-seek:3 '你好 Claude！'"
    exit 1
fi

WINDOW="$1"
shift  # 移除第一个参数，剩余部分是消息
MESSAGE="$*"

# 发送消息
tmux send-keys -t "$WINDOW" "$MESSAGE"

# 等待 0.5 秒让界面注册
sleep 0.5

# 发送 Enter 提交
tmux send-keys -t "$WINDOW" Enter

echo "消息已发送到 $WINDOW: $MESSAGE"
