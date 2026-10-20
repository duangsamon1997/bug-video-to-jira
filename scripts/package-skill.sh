#!/usr/bin/env bash
# สร้าง dist/bug-video-to-jira.zip สำหรับอัปโหลดใน Claude (Settings > Capabilities > Skills)
# ถ้ามี config/boards.local.md จะรวมไปด้วย (zip นี้ใช้ภายในทีม ห้ามแชร์ public)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/dist"
rm -f "$ROOT/dist/bug-video-to-jira.zip"
cd "$ROOT/skills"
zip -qr "$ROOT/dist/bug-video-to-jira.zip" bug-video-to-jira -x "*.DS_Store"
if [ -f bug-video-to-jira/config/boards.local.md ]; then
  echo "รวม boards.local.md (ค่าภายในทีม) ไว้ใน zip แล้ว ห้ามแชร์ zip นี้ public"
else
  echo "ไม่มี boards.local.md: skill จะดึง field จาก Jira เองทุกครั้ง"
fi
echo "สร้างไฟล์: $ROOT/dist/bug-video-to-jira.zip"
