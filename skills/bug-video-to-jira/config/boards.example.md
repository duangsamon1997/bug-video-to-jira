# Board config (ตัวอย่าง)

คัดลอกไฟล์นี้เป็น `boards.local.md` ในโฟลเดอร์เดียวกัน แล้วใส่ค่าจริงของทีม
`boards.local.md` อยู่ใน `.gitignore` จะไม่ขึ้น repo

หาค่าได้จาก Jira ด้วย `getVisibleJiraProjects` และ `getJiraIssueTypeMetaWithFields` หรือให้ Claude discover ให้แล้วคัดลอกมาใส่

## Sites

| Site | cloudId |
|---|---|
| <ชื่อ site> | `<your-site>.atlassian.net` |

## Board: <ชื่อ board ที่ผู้ใช้เรียก>

| Item | ค่า |
|---|---|
| Site | `<your-site>.atlassian.net` |
| Project key | `<KEY>` |
| Bug issue type id | `<id>` |
| Board id (ถ้ามี) | `<id>` |

| Field | Field id | ค่า / option id | Required |
|---|---|---|---|
| Pair Testing Status | `customfield_XXXXX` | To Do = `<id>` | <yes/no> |
| Severity | `customfield_XXXXX` | Urgent = `<id>`, High = `<id>`, Medium = `<id>`, Low = `<id>` | <yes/no> |
| Priority (number) | `customfield_XXXXX` | P1 = 1 … P4 = 4 | <yes/no> |
| Sprint | `customfield_XXXXX` | sprint id (number) | no |
| Fix versions | `fixVersions` | `[{"name": "<version>"}]` | no |
| QA Owner | `customfield_XXXXX` | `[{"accountId": "..."}]` (หลายคน) หรือ `{"accountId": "..."}` (คนเดียว) | no |
| Parent (Epic) | `parent` | `{"key": "<KEY>-xxx"}` | no |

**หมายเหตุของ board นี้:** (เช่น board เก็บ Test step / Actual / Expected ในช่องแยก, มี automation ใส่ sprint ให้เอง, ไม่มีช่อง Severity)

<!-- คัดลอกหัวข้อ "Board:" ซ้ำสำหรับ board อื่น -->
