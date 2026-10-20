---
name: bug-video-to-jira
description: อ่านวิดีโอหรือรูป bug (.mp4/.mov/.webm, รูปหน้าจอ, Google Drive link, BetterBugs link) แล้วเปิด Bug ticket บน Jira พร้อม Reproduce Steps, Actual Result และลิงก์หลักฐาน ใช้เมื่อผู้ใช้ส่งวิดีโอหรือรูป bug มาให้เปิด ticket
---

# Bug Video → Jira Ticket

เปลี่ยนวิดีโอหรือรูป bug ให้เป็น Bug ticket บน Jira ที่ dev อ่านแล้ว reproduce ได้ทันที

ไฟล์ที่เกี่ยวข้องในโฟลเดอร์ skill นี้:

| ไฟล์ | ใช้ทำอะไร |
|---|---|
| `config/boards.local.md` | ค่า Jira ของทีม (site, project key, field id) **อ่านไฟล์นี้ก่อนเสมอ** ถ้าไม่มี ให้ดู `config/boards.example.md` แล้ว discover จาก Jira แทน |
| `references/betterbugs.md` | กฎการอ่านลิงก์ BetterBugs |
| `references/video-reading.md` | วิธีตัด frame อ่านวิดีโอ และการซูมยืนยัน |
| `references/ticket-template.md` | รูปแบบ Summary / Description |

## กฎเหล็ก

1. **ห้ามเดา** ค่าต่อไปนี้ต้องได้จากผู้ใช้เท่านั้น:
   - Board / Project
   - Expected Result
   - Sprint
   - Fix version (ถามเฉพาะเมื่อมี sprint ถ้าไม่มี sprint ไม่ต้องถามและไม่ต้องใส่)
   - Summary prefix
   - Epic (Parent)
   - QA Owner
   - Severity / Priority (เสนอพร้อมเหตุผลได้ แต่ผู้ใช้ต้องเลือก)
   - field ที่ board บังคับกรอกแต่ไม่อยู่ในรายการนี้
2. ค่าที่ยังไม่ได้คำตอบให้ใส่ `<รอยืนยัน: ...>` ใน draft และห้ามสร้าง ticket ถ้ายังมีค่านี้เหลือ
3. **ห้ามสร้าง ticket จนกว่าผู้ใช้สั่งเปิดชัดเจน** เช่น "เปิด ticket" หรือ "ถ้าครบแล้วเปิดได้เลย" ถ้าผู้ใช้ตอบแค่ "ยืนยัน" ให้ถามซ้ำว่าจะเปิด ticket จริงเลยไหม
4. ถ้าผู้ใช้บอก "ไม่ใส่" field ไหน ห้ามใส่ field นั้น และห้ามย้ายค่าไปใส่ใน description แทน
5. Actual Result มีเฉพาะสิ่งที่เห็นจริงในวิดีโอหรือรูป ห้ามใส่ข้อสันนิษฐานเรื่องสาเหตุ ถ้ามีข้อสังเกต (เช่น ยืนยันได้แค่บางกรณี) ให้แจ้งผู้ใช้แยกต่างหาก
6. ห้ามรายงานว่าทำสำเร็จถ้ายังไม่ได้ตรวจกับ Jira

## Jira site และ board

1. **เลือก site:** ดูจาก board ใน `config/boards.local.md` หรือจาก domain ของลิงก์ Epic/ticket ที่ผู้ใช้ให้มา (`<site>.atlassian.net/browse/KEY-123`)
2. **เช็คสิทธิ์ทุกครั้งก่อนเริ่ม:** เรียก `getAccessibleAtlassianResources` ถ้า site ที่ต้องใช้ไม่อยู่ในรายการ หรือได้ error "isn't explicitly granted by the user" ให้หยุดแล้วบอกผู้ใช้:
   > ไปที่ Settings > Connectors > Atlassian → Disconnect → Connect ใหม่ แล้วในหน้าขออนุญาตของ Atlassian เลือกทุกไซต์ที่ต้องใช้

   ห้ามพยายาม grant สิทธิ์เอง ระหว่างรอทำ draft ได้ แต่ค่าที่ต้องตรวจกับ Jira ให้เป็น `<รอยืนยัน>`
3. **Board ที่มีใน config:** ใช้ field id จาก config ได้เลย
4. **Board ที่ไม่มีใน config:** discover ใหม่ ห้ามใช้ field id ของ board อื่น
   1. `getVisibleJiraProjects` (searchString = ชื่อ board) → project key และ Bug type id
   2. `getJiraIssueTypeMetaWithFields` (requiredFieldsOnly `false`) → map ชื่อ field เป็น id/option id และจดว่า field ไหน required
   3. ดู bug ล่าสุด 1-2 ใบ (`searchJiraIssuesUsingJql`) เพื่อดู format และค่าที่ทีมใช้บ่อย
   4. field ที่ไม่มีใน board → แจ้งผู้ใช้ในตาราง draft
   5. field ที่ required แต่ไม่อยู่ในคำถามปกติ → ถามผู้ใช้เพิ่ม เสนอค่าที่ทีมใช้บ่อยเป็นตัวเลือกได้
   6. แนะนำผู้ใช้ให้เพิ่ม board นี้ลง `config/boards.local.md` (ใส่ค่าที่ discover ได้ให้)
5. **Pair Testing Status (ถ้า board มี):** ใช้ option "To Do" เสมอ

## Workflow

### Step 1: รับหลักฐาน แยกตามแหล่ง

| แหล่ง | วิธีอ่าน | Result / การแนบ |
|---|---|---|
| ไฟล์วิดีโอที่แนบในแชท (.mp4/.mov/.webm) | ffmpeg ตาม `references/video-reading.md` | ถ้ามีไฟล์เดียวกันบน Drive ให้ใช้ลิงก์ Drive เป็น Result ไม่งั้นเขียน "ดูวิดีโอใน Attachment" ให้ผู้ใช้ลากไฟล์ใส่เอง |
| รูปหน้าจอที่แนบในแชท | ดูรูปโดยตรง ซูมจุดสำคัญถ้าจำเป็น ถ้าแนบหลายรูปที่เหมือนกัน ให้ถามว่าตั้งใจแนบกี่รูป | "ดูรูปใน Attachment" ผู้ใช้ลากใส่เอง |
| Google Drive link ไฟล์ | `get_file_metadata` ดูขนาดก่อน ถ้าไม่เกิน ~5MB ใช้ `download_file_content` ได้ ถ้าใหญ่กว่านั้น **ห้ามลองดาวน์โหลดผ่าน connector** (connector จะตัดการเชื่อมต่อ) ให้ใช้ทางเลือกใน "ไฟล์ใหญ่" | ลิงก์ Drive เป็น Result |
| Google Drive link โฟลเดอร์ | `search_files` ด้วย `parentId = '<folderId>'` แล้วถามผู้ใช้ว่าจะเปิด ticket จากไฟล์ไหน (1 วิดีโอ = 1 ticket) | เหมือน Drive file |
| BetterBugs link | ตาม `references/betterbugs.md` | ลิงก์ BetterBugs เป็น Result |

**ไฟล์ใหญ่ / ดึงไม่ได้ ทางเลือกตามลำดับ:**
1. ผู้ใช้วางไฟล์ในโฟลเดอร์บนเครื่องที่เชื่อมกับ session ไว้ แล้วบอกชื่อไฟล์ → ดึงไฟล์มาอ่าน (ถ้ายังไม่มีโฟลเดอร์เชื่อม ขอสิทธิ์ครั้งเดียว)
2. ผู้ใช้แนบไฟล์ในแชท

ชื่อไฟล์หรือหัวข้อใน BetterBugs เป็นแค่ hint ให้เชื่อสิ่งที่เห็นในวิดีโอมากกว่า

### Step 2: อ่านวิดีโอ

ทำตาม `references/video-reading.md` (ตัด frame ทุก 2 วินาที, contact sheet, ซูมยืนยันข้อความเล็กหรือไอคอน, จด timestamp)

### Step 3: ถามผู้ใช้

ก่อนถาม สรุปสั้นๆ ว่าเห็นอะไร (flow + จุดที่เป็น bug + ข้อจำกัดที่ยืนยันไม่ได้)

ถ้าผู้ใช้ส่ง template ค่าครบมาแล้ว ข้ามไป Step 4 ได้เลย ไม่งั้นถาม:
- **รอบ 1:** Board, Expected Result (+ requirement อ้างอิง), Severity/Priority
- **รอบ 2 (หลังรู้ board):** Sprint (ดึง sprint active/future ของ board มาเป็นตัวเลือก), Summary prefix, Epic, QA Owner, field required เพิ่มเติมของ board
- **รอบ 3:** Fix version (เฉพาะเมื่อมี sprint ดึงรายชื่อที่ `released: false` มาให้เลือก ห้ามจับคู่กับ sprint เอง)

ถ้าใช้เครื่องมือถามแบบตัวเลือก ต้องมีอย่างน้อย 2 ตัวเลือกต่อคำถาม คำถามที่เป็น free text (Epic key, ชื่อ QA Owner) ให้ถามในข้อความปกติ

Template ที่ผู้ใช้มักส่งมา:
```
Board:
Expected Result:
Requirement อ้างอิง:
Severity / Priority:
Sprint:
Fix version:
Summary prefix:
Epic:
QA Owner:
```

### Step 4: Validate กับ Jira

- **Site:** เช็คสิทธิ์ตามหัวข้อ "Jira site และ board"
- **Sprint id:** ถ้าผู้ใช้ให้ลิงก์ที่มี `sprintId=` ใช้ id นั้นได้ แต่ต้องยืนยันด้วย JQL `project = <KEY> AND sprint = <id>` ว่ามีจริงและยัง active/future ไม่งั้นใช้ JQL `sprint = "<ชื่อ>"` แล้วดึง id ของ sprint ที่ชื่อตรงกัน ถ้า sprint เลยวันจบแล้วแต่ยัง active ให้แจ้งผู้ใช้
- **Fix version:** ชื่อต้องตรงกับ `fixVersions.allowedValues` ทุกตัวอักษร
- **QA Owner:** ถ้าผู้ใช้บอก "ฉัน" ใช้ `atlassianUserInfo` คนอื่นใช้ `lookupJiraAccountId` ทีละคน ต้องเจอคนเดียวและ `active: true` ถ้าเจอหลายคนให้แสดง displayName + email ให้ผู้ใช้เลือก ถ้าค้นด้วยอีเมลไม่เจอ (เช่น domain พิมพ์ผิด) ให้ค้นด้วยส่วนหน้า @ แล้วให้ผู้ใช้ยืนยัน ห้ามใช้เองโดยไม่ถาม
- **Epic:** `getJiraIssue` ตรวจว่ามีจริงและเป็น Epic แสดงชื่อใน draft ถ้าชื่อดูไม่เกี่ยวกับ bug ให้ทักผู้ใช้ (แต่ห้ามเปลี่ยนเอง)

### Step 5: Draft

เขียนตาม `references/ticket-template.md` แล้วแสดง:
- Summary
- ตาราง fields: Board, Severity/Priority, Sprint, Fix version, Epic (key + ชื่อ), QA Owner (ชื่อ + อีเมล), Pair Testing Status, field ที่ board ไม่มี
- Description (และ field แยกถ้า board เก็บ steps/actual/expected ในช่องของตัวเอง)

แล้วรอคำสั่งเปิด

### Step 6: สร้าง ticket

`createJiraIssue` ด้วย cloudId ของ site นั้น, `contentFormat: "markdown"`, field ตาม config ของ board ใน `additional_fields`

หลังสร้าง `getJiraIssue` เช็คทุก field ที่ใส่ไป และเช็คว่าไม่มี sprint ถูกใส่เพิ่มเอง (บาง board มี automation ใส่ sprint ให้) ถ้าผิดใช้ `editJiraIssue` แก้ (เช่น ตั้ง sprint field เป็น `null`)

### Step 7: แนบไฟล์

**แนบอัตโนมัติไม่ได้ (ทดสอบแล้ว):** Jira MCP ไม่มีคำสั่งอัปโหลด และการอัปโหลดผ่าน Claude in Chrome ถูกปฏิเสธทั้งไฟล์ใน cloud workspace และไฟล์ในโฟลเดอร์บนเครื่อง ห้ามเสียเวลาลองใหม่

- ลิงก์ Drive / BetterBugs: ใส่ใน Result ก็พอ ไม่ต้องแนบไฟล์
- ไฟล์ที่แนบในแชทและไม่มีลิงก์: บอกผู้ใช้ให้ลากไฟล์ใส่ Attachment เอง ถ้าไฟล์ใหญ่เกิน 10MB และผู้ใช้อยากได้ไฟล์เล็ก บีบอัดให้:
  ```bash
  ffmpeg -v error -y -i "$V" -vf "scale='min(1280,iw)':-2,fps=15" -c:v libx264 -preset veryfast -crf 30 -an -movflags +faststart <output>.mp4
  ```
  ถ้ายังเกิน 10MB ให้เพิ่ม crf เป็น 32-35 หรือลด fps เป็น 10 / scale เป็น 960 ถ้าเสียงสำคัญ เอา `-an` ออกแล้วใช้ `-c:a aac -b:a 64k`

### Step 8: สรุป

ตอบสั้นๆ: ลิงก์ ticket, ค่าที่ตรวจแล้ว (Severity/Priority, Sprint, Fix version, Epic, QA Owner, Pair Testing Status), สิ่งที่ Jira ทำเอง (เช่น sprint อัตโนมัติ), และไฟล์ที่ผู้ใช้ต้องแนบเอง

## Checklist ก่อนสร้าง

- [ ] เช็คสิทธิ์ site แล้ว
- [ ] ค่าทุกตัวมาจากผู้ใช้ ไม่มี `<รอยืนยัน>` เหลือ
- [ ] field ที่ผู้ใช้บอก "ไม่ใส่" ไม่ถูกใส่ทั้งใน field และ description
- [ ] ไม่มี sprint → ไม่มี fix version / มี sprint → มี fix version ที่ชื่อตรงกับ Jira
- [ ] QA Owner และ Epic ตรวจกับ Jira แล้ว
- [ ] Actual Result มีเฉพาะสิ่งที่เห็นจริง ข้อความเล็กหรือไอคอนซูมยืนยันแล้ว
- [ ] Result มีลิงก์หลักฐาน หรือบอกผู้ใช้ให้แนบไฟล์เอง
- [ ] ผู้ใช้สั่งเปิด ticket ชัดเจน
- [ ] 1 วิดีโอ = 1 ticket (ถามก่อนถ้าวิดีโอเดียวมีหลาย bug)
