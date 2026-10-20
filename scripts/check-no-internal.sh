#!/usr/bin/env bash
# กันค่าภายในหลุดขึ้น repo: ตรวจไฟล์ที่ git track ว่าไม่มี atlassian site จริง หรือ customfield id จริง
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
if git ls-files | grep -q 'boards.local.md'; then
  echo "พบ boards.local.md ใน git ห้าม commit"; fail=1
fi
if git ls-files -z | xargs -0 grep -nE '[a-z0-9-]+\.atlassian\.net' | grep -v '<your-site>\|<site>' ; then
  echo "พบชื่อ Atlassian site จริงในไฟล์ข้างบน"; fail=1
fi
if git ls-files -z | xargs -0 grep -nE 'customfield_[0-9]{4,}'; then
  echo "พบ customfield id จริงในไฟล์ข้างบน"; fail=1
fi
[ $fail -eq 0 ] && echo "ไม่พบค่าภายใน"
exit $fail
