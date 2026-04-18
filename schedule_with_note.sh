#!/bin/bash
# 带有备注的动态调度器
# 用法: ./schedule_with_note.sh <分钟> "<备注>" [目标窗口]

MINUTES=${1:-3}
NOTE=${2:-"标准签到"}
TARGET=${3:-"tmux-orc:0"}

# 创建下次检查的备注文件
echo "=== 下次检查备注 ($(date)) ===" > /Users/bing/fancy/ai/Tmux-Orchestrator/next_check_note.txt
echo "计划时间: $MINUTES 分钟" >> /Users/bing/fancy/ai/Tmux-Orchestrator/next_check_note.txt
echo "" >> /Users/bing/fancy/ai/Tmux-Orchestrator/next_check_note.txt
echo "$NOTE" >> /Users/bing/fancy/ai/Tmux-Orchestrator/next_check_note.txt

echo "计划在 $MINUTES 分钟后检查，备注: $NOTE"

# 计算检查将运行的确切时间
CURRENT_TIME=$(date +"%H:%M:%S")
RUN_TIME=$(date -v +${MINUTES}M +"%H:%M:%S" 2>/dev/null || date -d "+${MINUTES} minutes" +"%H:%M:%S" 2>/dev/null)

# 使用 nohup 完全分离 sleep 进程
# 使用 bc 进行浮点运算
SECONDS=$(echo "$MINUTES * 60" | bc)
nohup bash -c "sleep $SECONDS && tmux send-keys -t $TARGET 'Time for orchestrator check! cat /Users/bing/fancy/ai/Tmux-Orchestrator/next_check_note.txt && python3 claude_control.py status detailed' && sleep 1 && tmux send-keys -t $TARGET Enter" > /dev/null 2>&1 &

# 获取后台进程的 PID
SCHEDULE_PID=$!

echo "调度成功 - 进程已分离 (PID: $SCHEDULE_PID)"
echo "计划执行时间: $RUN_TIME ($CURRENT_TIME 后 $MINUTES 分钟)"
