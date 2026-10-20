# กฎการเชื่อมต่อ BetterBugs

ลิงก์รูปแบบ `https://app.betterbugs.io/session/<bug_id>?...` → `bug_id` คือส่วนหลัง `/session/` ก่อน `?`

## ตั้งค่าครั้งเดียว

| สิ่งที่ต้องมี | ใช้ทำอะไร | ใครทำ |
|---|---|---|
| BetterBugs connector | ดึงข้อมูล bug, user steps, console, network | ผู้ใช้ เชื่อมใน Settings > Connectors |
| โดเมน `cdn-butterfly-new.betterbugs.io` ในรายชื่อโดเมนที่อนุญาต | ดาวน์โหลดไฟล์วิดีโอ (ไฟล์อยู่บนโดเมนนี้ ไม่ใช่โดเมนของ connector) | admin ของ Claude ที่ Admin/Organization settings > Capabilities (มักมีผลกับ session ใหม่) |

## ลำดับการอ่าน

1. `getBugDetails(bug_id)` → title, priority, project/workspace id, `page_info.url` (Environment), `system_info` (browser/OS), `screen_recording.url` และ `duration`
2. `getBugLogs(bug_id)` → user steps (click / navigate พร้อม URL), console error, network ที่ล้มเหลว
3. ถ้า bug มี screenshot → `getScreenshot(bug_id)`
4. ดาวน์โหลดวิดีโอมาอ่านเอง (หลักฐานหลัก):
   ```bash
   curl -sS -m 90 -o <scratch>/bb/v.webm -w "%{http_code} %{size_download}\n" "<screen_recording.url>"
   ```
   ได้ 200 แล้วอ่านตาม `video-reading.md` (ffmpeg อ่าน .webm/vp9 ได้ แต่ ffprobe อาจไม่บอก duration ให้ใช้ค่าจาก getBugDetails)
5. ถ้า curl ได้ 403 / `connect_rejected` แปลว่าโดเมนยังไม่ได้รับอนุญาต:
   - **ห้ามพยายามเล่นวิดีโอใน Claude in Chrome** (ทดสอบแล้ว ทั้งหน้า BetterBugs, ไฟล์ .webm ตรงๆ และ blob ไม่โหลดภาพเลย)
   - บอกผู้ใช้ให้ admin เพิ่มโดเมน หรือกด Download ใน BetterBugs แล้ววางไฟล์ในโฟลเดอร์ที่เชื่อมไว้ / แนบในแชท
   - ระหว่างนั้นร่าง draft จาก steps + logs ได้ แต่ Actual Result ต้องเป็น `<รอยืนยัน>` หรือมาจากคำอธิบายของผู้ใช้
6. `getVideoAnalysis` เป็นทางเสริม (สรุปเป็นข้อความ) อาจได้ 403 "Video analysis is currently disabled" ถ้า workspace ปิดไว้ ไม่ต้องพึ่ง ถ้าได้ผลและ `hasSpeech: true` ให้เรียก `getTranscription` ต่อ

## การใช้ข้อมูลจาก BetterBugs

- **Environment:** domain/URL จาก `page_info`, Browser/OS จาก `system_info`
- **Reproduce Steps:** user steps ช่วยได้ แต่ต้องเทียบกับภาพในวิดีโอ (event บางตัวเป็นแค่ click บนพื้นที่ว่าง)
- **Network error ที่ไม่เกี่ยวกับ bug** (เช่น 401 ตอนเริ่มอัด) ห้ามใส่ใน Actual ถ้าจะบอก ให้แจ้งผู้ใช้แยก
- **Result:** ใช้ลิงก์ `https://app.betterbugs.io/session/<bug_id>` (ตัด query string) ชื่อลิงก์ใช้ title ของ bug
- ไม่ต้องแนบไฟล์วิดีโอเข้า ticket
