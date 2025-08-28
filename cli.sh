#!/usr/bin/env bash
set -e

# 配色
GREEN="\033[32m"; CYAN="\033[36m"; MAGENTA="\033[35m"; RESET="\033[0m"

# 标题（可选）
TITLE=$(figlet -f Small "NANOCODER")
echo -e "$TITLE"

# 欢迎面板
gum style \
  --border normal --margin "0 0" --padding "1 1" \
  --border-foreground magenta \
  "* Welcome to Nanocoder 1.4.0
$CYAN Tips for getting started:$RESET

1. Use natural language to describe what you want to build.
2. Ask for file analysis, editing, bash commands and more.
3. Be specific as you would with another engineer for best results.
4. Type /exit or press Ctrl+C to quit.

Type /help for help
"

# 状态面板
CWD="$(pwd)"
PROVIDER="openrouter"
MODEL="x-ai/grok-code-fast-1"
gum style \
  --border normal --padding "1 1" --border-foreground blue \
  "CWD: $CWD
Provider: $PROVIDER, Model: $MODEL"

echo -e "${GREEN}User preferences loaded...${RESET}\n"

# 问句
QUESTION="What files are in my current working directory?"
echo -e "${CYAN}You:${RESET} $QUESTION"

# 命令块
CMD_DEFAULT="ls"
gum style --border normal --padding "0 1" --border-foreground magenta \
  "✱ execute_bash
Command: ${CMD_DEFAULT}"

# 是否执行
CHOICE=$(gum choose "✓ Yes, execute this tool" "✗ No, cancel execution" --cursor-prefix "➤ ")
if [[ "$CHOICE" != "✓ Yes, execute this tool" ]]; then
  echo "Canceled."
  exit 0
fi

# 可允许用户修改命令（回车用默认）
CMD=$(gum input --placeholder "$CMD_DEFAULT")
CMD=${CMD:-$CMD_DEFAULT}

echo
echo -e "${MAGENTA}Running:${RESET} $CMD"
echo

# 执行并高亮输出
if OUTPUT=$(bash -lc "$CMD" 2>&1); then
  echo "$OUTPUT" | gum style --border normal --padding "1 1" --border-foreground green
else
  echo "$OUTPUT" | gum style --border normal --padding "1 1" --border-foreground red
fi

echo
gum confirm "Press Enter to exit" >/dev/null || true