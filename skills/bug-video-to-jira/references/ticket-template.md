# รูปแบบ ticket

## Summary

`<prefix> <หน้าจอ/ฟีเจอร์> (<role>): <อาการ bug สั้น ชัด>`

ตัวอย่าง: `[UAT] ตารางเรียน (นักเรียน): เลือก filter วิชาในแผนเฉพาะแล้วทุกคาบเป็นสีจาง`

## Description (markdown)

```
**Following to** [<KEY>-xxx](<url>)   ← เฉพาะเมื่อมี requirement อ้างอิง

**Environment:** <domain> | Role: <role> (<ชื่อ user, หน่วยงาน>) | <ช่วงเวลา/ภาคเรียน ถ้ามี> | <Browser/OS>

**Precondition:**
* <state/data ที่ต้องมีก่อน>

**Reproduce Steps:**
1. Log in เป็น <role>
2. ไปที่เมนู <เมนู> > <เมนูย่อย>
3. เลือก <dropdown> = "<ค่า>"

**Actual Results:**
* <สิ่งที่เห็นจริง พร้อม timestamp เช่น (วิดีโอ 0:10)>

**Expected Results:**
* <ตามที่ผู้ใช้ให้มา>

**Result:** [<ชื่อ>](<ลิงก์ Drive / BetterBugs>)   หรือ "ดูวิดีโอ/รูปใน Attachment"
```

ถ้า board เก็บ Test step / Actual / Expected ในช่องแยก (ดู config) ให้ใส่ในช่องนั้น และ description เหลือแค่ Environment + Precondition + Result

## กติกา

- 1 step = 1 action ขึ้นต้นด้วย action (Log in, ไปที่, Click, เลือก, กรอก)
- ใช้ชื่อเมนู/ปุ่ม/ฟิลด์ตาม UI จริง ใส่ "" ครอบค่า
- ใส่ test data จริงที่เห็นในวิดีโอ
- ห้ามใส่ expected ปนใน steps
- หลาย case ในวิดีโอเดียว แยก `\[Positive case\]` / `\[Negative case\]` (escape วงเล็บเหลี่ยมใน markdown)
- Actual Result มีเฉพาะสิ่งที่เห็นจริง ห้ามใช้คำกว้างๆ เช่น "ทำงานไม่ถูกต้อง"
