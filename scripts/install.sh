#!/usr/bin/env bash
# ติดตั้ง skill สำหรับ Claude Code: clone repo แล้ว symlink skill และ command เข้า ~/.claude
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/<owner>/bug-video-to-jira.git}"
DEST="${BVTJ_HOME:-$HOME/.bug-video-to-jira}"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

if [ -d "$DEST/.git" ]; then
  git -C "$DEST" pull --ff-only
else
  git clone --depth 1 "$REPO_URL" "$DEST"
fi

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
ln -sfn "$DEST/skills/bug-video-to-jira" "$CLAUDE_DIR/skills/bug-video-to-jira"
ln -sfn "$DEST/commands/bug-video-to-jira.md" "$CLAUDE_DIR/commands/bug-video-to-jira.md"

CFG="$DEST/skills/bug-video-to-jira/config"
if [ ! -f "$CFG/boards.local.md" ]; then
  cp "$CFG/boards.example.md" "$CFG/boards.local.md"
  echo "สร้าง $CFG/boards.local.md แล้ว ใส่ค่า Jira ของทีมก่อนใช้งาน"
fi

echo "ติดตั้งเสร็จ: $CLAUDE_DIR/skills/bug-video-to-jira"
echo "ใช้งานใน Claude Code ด้วย /bug-video-to-jira"
