# Changelog

## 1.0.0

- เปิด Bug ticket บน Jira จากไฟล์วิดีโอ, รูปหน้าจอ, Google Drive และ BetterBugs
- รองรับหลาย Jira site และหลาย board ผ่าน `config/boards.local.md` (board ที่ไม่มีใน config จะดึง field จาก Jira เอง)
- กฎการเชื่อมต่อ BetterBugs: connector + ดาวน์โหลดวิดีโอจาก CDN มาตัด frame อ่านเอง
- ซูมยืนยันข้อความเล็กหรือไอคอนก่อนเขียน Actual Result
- ไม่สร้าง ticket จนกว่าผู้ใช้สั่งเปิด และตรวจทุก field กับ Jira หลังสร้าง
