![编排器英雄](/Orchestrator.png)

**让你在睡眠时 AI 代理也能 24/7 工作** - Tmux 编排器使 Claude 代理能够自主工作、自行安排签到、并在多个项目之间协调，无需人工干预。

## 🤖 关键能力与自主特性

- **自我触发** - 代理自行安排签到并自主继续工作
- **协调** - 项目经理跨多个代码库为工程师分配任务
- **持久** - 即使你关闭笔记本，工作仍继续
- **扩展** - 同时运行多个团队处理不同项目

## 🏗️ 架构

Tmux 编排器使用三层架构来克服上下文窗口限制：

```
┌─────────────┐
│   编排器    │ ← 你在这里交互
└──────┬──────┘
       │ 监控与协调
       ▼
┌─────────────┐     ┌─────────────┐
│  项目经理 1  │     │  项目经理 2  │ ← 分配任务，执行规范
└──────┬──────┘     └──────┬──────┘
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│   工程师 1   │     │   工程师 2   │ ← 编写代码，修复 bug
└─────────────┘     └─────────────┘
```

### 为什么分离代理？
- **上下文窗口有限** - 每个代理专注于其角色
- **专业知识** - 项目经理管理，工程师编码
- **并行工作** - 多个工程师可同时工作
- **更好的记忆** - 更小的上下文意味着更好的回忆

## 📸 实际运行示例

### 项目经理协调
![启动项目经理](Examples/Initiate%20Project%20Manager.png)
*编排器正在创建并引导新的项目经理代理*

### 状态报告与监控
![状态报告](Examples/Status%20reports.png)
*多个代理并行工作的实时更新*

### Tmux 通信
![读取 TMUX 窗口和发送消息](Examples/Reading%20TMUX%20Windows%20and%20Sending%20Messages.png)
*代理如何跨 tmux 窗口和会话进行通信*

### 项目完成
![项目已完成](Examples/Project%20Completed.png)
*成功完成项目，所有任务已验证并提交*

## 🎯 快速开始

### 选项 1：基础设置（单项目）

```bash
# 1. 创建项目规范
cat > project_spec.md << 'EOF'
PROJECT: 我的 Web 应用
GOAL: 添加用户认证系统
CONSTRAINTS:
- 使用现有数据库架构
- 遵循当前代码模式
- 每 30 分钟提交一次
- 为新功能编写测试

DELIVERABLES:
1. 登录/登出端点
2. 用户会话管理
3. 受保护路由中间件
EOF

# 2. 启动 tmux 会话
tmux new-session -s my-project

# 3. 在窗口 0 启动项目经理
claude --dangerously-skip-permissions

# 4. 给项目经理规范并让它创建一个工程师
"你是项目经理。阅读 project_spec.md 并在窗口 1 创建一个工程师来实现它。每 30 分钟安排一次签到。"

# 5. 安排编排器签到
./schedule_with_note.sh 30 "检查认证系统进度"
```

### 选项 2：完整编排器设置

```bash
# 启动编排器
tmux new-session -s orchestrator
claude --dangerously-skip-permissions

# 给它你的项目
"你是编排器。为以下项目设置项目经理：
1. 前端（React 应用）- 添加仪表板图表
2. 后端（FastAPI）- 优化数据库查询
每小时安排自己签到一次。"
```

## ✨ 关键特性

### 🔄 自我安排代理
代理可使用以下命令自行安排签到：
```bash
./schedule_with_note.sh 30 "继续仪表板实现"
```

### 👥 多代理协调
- 项目经理与工程师沟通
- 编排器监控所有项目经理
- 跨项目知识共享

### 💾 自动 Git 备份
- 每 30 分钟工作提交一次
- 标记稳定版本
- 为实验创建功能分支

### 📊 实时监控
- 查看每个代理在做什么
- 需要时介入
- 审查所有项目的进度

## 📋 最佳实践

### 编写有效规范

```markdown
PROJECT: 电商结账
GOAL: 实现多步骤结账流程

CONSTRAINTS:
- 使用现有的购物车状态管理
- 遵循当前设计系统
- 最多 3 个 API 端点
- 每步完成后提交

DELIVERABLES:
1. 带验证的收货地址表单
2. 支付方式选择（Stripe 集成）
3. 订单审核和确认页面
4. 成功/失败处理

SUCCESS CRITERIA:
- 所有表单正确验证
- 支付处理无错误
- 订单数据持久化到数据库
- 完成后发送邮件
```

### Git 安全规则

1. **开始任何任务前**
   ```bash
   git checkout -b feature/[任务名称]
   git status  # 确保状态干净
   ```

2. **每 30 分钟**
   ```bash
   git add -A
   git commit -m "进度：[完成了什么]"
   ```

3. **任务完成后**
   ```bash
   git tag stable-[功能]-[日期]
   git checkout main
   git merge feature/[任务名称]
   ```

## 🚨 常见陷阱与解决方案

| 陷阱 | 后果 | 解决方案 |
|---------|-------------|----------|
| 模糊的指令 | 代理偏离目标，浪费算力 | 编写清晰、具体的规范 |
| 没有 git 提交 | 丢失工作，代理沮丧 | 执行 30 分钟提交规则 |
| 任务过多 | 上下文超载，混乱 | 一次一个代理一个任务 |
| 没有规范 | 不可预测的结果 | 始终从书面规范开始 |
| 缺少检查点 | 代理停止工作 | 安排定期签到 |

## 🛠️ 工作原理

### Tmux 的魔力
Tmux（终端复用器）是关键赋能工具，因为：
- 即使断开连接也能持久化终端会话
- 允许一个会话内有多个窗口/面板
- Claude 运行在终端中，因此它可以控制其他 Claude 实例
- 命令可以以编程方式发送到任何窗口

### 💬 简化的代理通信

我们现在使用 `send-claude-message.sh` 脚本进行所有代理通信：

```bash
# 向任何 Claude 代理发送消息
./send-claude-message.sh session:window "你的消息"

# 示例：
./send-claude-message.sh frontend:0 "登录表单进度如何？"
./send-claude-message.sh backend:1 "API 端点 /api/users 返回 404"
./send-claude-message.sh project-manager:0 "请与 QA 团队协调"
```

该脚本自动处理所有定时复杂性，使代理通信可靠且一致。

### 安排签到
```bash
# 使用具体的、可操作的笔记安排
./schedule_with_note.sh 30 "审查认证实现，分配下一个任务"
./schedule_with_note.sh 60 "检查测试覆盖率，通过则合并"
./schedule_with_note.sh 120 "完整系统检查，需要时轮换任务"
```

**重要**：编排器需要知道它运行在哪个 tmux 窗口才能正确自行安排签到。如果签到不工作，请验证编排器知道当前窗口：
```bash
echo "当前窗口: $(tmux display-message -p "#{session_name}:#{window_index}")"
```

## 🎓 高级用法

### 多项目编排
```bash
# 启动编排器
tmux new-session -s orchestrator

# 为每个项目创建项目经理
tmux new-window -n frontend-pm
tmux new-window -n backend-pm  
tmux new-window -n mobile-pm

# 每个项目经理管理自己的工程师
# 编排器在项目经理之间协调
```

### 跨项目智能
编排器可以在项目之间共享洞察：
- "前端使用 /api/v2/users，相应地更新后端"
- "项目 A 中认证工作正常，在项目 B 中使用相同模式"
- "在共享库中发现性能问题，在所有项目中修复"

## 📚 核心文件

- `send-claude-message.sh` - 简化的代理通信脚本
- `schedule_with_note.sh` - 自我安排功能
- `tmux_utils.py` - Tmux 交互工具
- `CLAUDE.md` - 代理行为指令
- `LEARNINGS.md` - 积累的知识库

## 🤝 贡献与优化

编排器通过社区发现和优化不断演进。贡献时：

1. 在 CLAUDE.md 中记录新的 tmux 命令和模式
2. 分享新颖的用例和代理协调策略
3. 提交 Claude 同步的优化方案
4. 保持命令参考与最新发现同步
5. 跨多个会话和场景测试改进

需要增强的关键领域：
- 代理通信模式
- 跨项目协调
- 新颖的自动化工作流

## 📄 许可证

MIT 许可证 - 自由但明智地使用。记住：能力越大，责任越大。

---

*"我们今天构建的工具，明天将自行编程"* - 艾伦·凯，1971
