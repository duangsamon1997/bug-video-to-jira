# bug-video-to-jira

**English summary:** An Agent Skill for Claude that reads a bug video or screenshot (file attachment, Google Drive link, or BetterBugs session) and opens a Jira bug ticket with reproduce steps, actual result, and an evidence link. It never guesses ticket fields (board, sprint, epic, owner, severity), always shows a draft first, and verifies every field in Jira after creating the ticket. Works with multiple Jira sites and boards via a local config file. The skill instructions are written in Thai.

---

Skill สำหรับ Claude: อ่านวิดีโอหรือรูป bug แล้วเปิด Bug ticket บน Jira พร้อม Reproduce Steps, Actual Result และลิงก์หลักฐาน

## ทำอะไรได้

- อ่านหลักฐานได้ 4 แบบ: ไฟล์วิดีโอ (.mp4 / .mov / .webm), รูปหน้าจอ, ลิงก์ Google Drive, ลิงก์ BetterBugs
- ตัด frame วิดีโอ อ่าน URL / เมนู / ค่าที่เลือก และซูมยืนยันข้อความเล็กหรือไอคอนก่อนเขียน Actual Result
- รองรับหลาย Jira site และหลาย board ถ้า board ไม่มีใน config จะดึง field จาก Jira เอง
- ไม่เดาค่า field ไหนเลย และไม่สร้าง ticket จนกว่าคุณสั่งเปิด
- หลังสร้าง ตรวจทุก field กับ Jira อีกรอบ (รวมถึง sprint ที่ automation ใส่เข้ามาเอง)

## โครงสร้าง repo

```
.claude-plugin/          plugin.json, marketplace.json (สำหรับ Claude Code plugin)
commands/                /bug-video-to-jira (Claude Code slash command)
skills/bug-video-to-jira/
  SKILL.md               ขั้นตอนหลัก
  references/            betterbugs.md, video-reading.md, ticket-template.md
  config/                boards.example.md (ตัวอย่าง), boards.local.md (ค่าจริงของทีม, ไม่ขึ้น repo)
scripts/                 install.sh, package-skill.sh, check-no-internal.sh
```

## ติดตั้ง

### Claude (แอป / เว็บ / Cowork)

1. Clone repo แล้วคัดลอก `skills/bug-video-to-jira/config/boards.example.md` เป็น `boards.local.md` ใส่ค่า Jira ของทีม (ข้ามได้ ถ้าจะให้ skill ดึง field จาก Jira เองทุกครั้ง)
2. รัน `scripts/package-skill.sh` จะได้ไฟล์ `dist/bug-video-to-jira.zip`
3. ใน Claude ไปที่ Settings > Capabilities > Skills แล้วอัปโหลด zip นั้น

zip ที่มี `boards.local.md` เป็นข้อมูลภายในทีม ห้ามแชร์ public

### Claude Code

```bash
REPO_URL=https://github.com/<owner>/bug-video-to-jira.git bash scripts/install.sh
```

หรือติดตั้งเป็น plugin จาก `.claude-plugin/marketplace.json`

## ตั้งค่าก่อนใช้

| สิ่งที่ต้องมี | ใช้ทำอะไร | หมายเหตุ |
|---|---|---|
| Atlassian connector | สร้าง/อ่าน ticket | ตอน Connect ให้เลือกทุก Jira site ที่ใช้ |
| BetterBugs connector | อ่านข้อมูล bug, steps, logs | เฉพาะคนที่ใช้ BetterBugs |
| โดเมน `cdn-butterfly-new.betterbugs.io` | ดาวน์โหลดวิดีโอ BetterBugs มาอ่าน | admin เพิ่มที่ Admin/Organization settings > Capabilities |
| Google Drive connector | อ่านวิดีโอจากลิงก์ Drive | ไฟล์ใหญ่กว่า ~5MB ดึงผ่าน connector ไม่ได้ ให้แนบไฟล์หรือวางในโฟลเดอร์ที่เชื่อมไว้ |
| โฟลเดอร์ที่เชื่อมในแอป Claude (ไม่บังคับ) | ส่งไฟล์ใหญ่ให้ Claude อ่านโดยไม่ต้องแนบในแชท | |

**ข้อจำกัด:** Claude แนบไฟล์เข้า Jira ticket ให้อัตโนมัติไม่ได้ ใช้ลิงก์ Drive / BetterBugs ใน Result แทน หรือลากไฟล์ใส่ Attachment เอง

## วิธีใช้

```
ใช้ skill bug-video-to-jira เปิด Bug ticket จากหลักฐานนี้
หลักฐาน: [แนบไฟล์วิดีโอ/รูป หรือวางลิงก์ Google Drive / BetterBugs]

Board:
Expected Result:
Requirement อ้างอิง:
Severity / Priority:
Sprint:
Fix version:            (ใส่เมื่อมี sprint เท่านั้น)
Summary prefix:
Epic:
QA Owner:

ขอดู draft ก่อน ยังไม่ต้องเปิดบน Jira จริง
```

ช่องไหนเว้นว่าง skill จะถามเอง ถ้าต้องการให้เปิดทันทีเมื่อค่าครบ เปลี่ยนบรรทัดสุดท้ายเป็น "ถ้าครบแล้วเปิด ticket ได้เลย"

## ก่อน commit

รัน `scripts/check-no-internal.sh` เพื่อตรวจว่าไม่มีชื่อ Jira site จริง, customfield id จริง หรือ `boards.local.md` หลุดเข้า repo

## License

MIT
