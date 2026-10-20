# วิธีอ่านวิดีโอ

ทำงานใน scratchpad แยกโฟลเดอร์ต่อวิดีโอ

```bash
V=<path วิดีโอ>; W=<scratchpad>/<ชื่อ>; mkdir -p $W/frames
ffprobe -v error -show_entries format=duration:stream=codec_name,width,height -of csv=p=0 "$V"
ffmpeg -v error -i "$V" -vf "fps=1/2,scale=1600:-1" $W/frames/t_%03d.jpg   # ยาวกว่า 2 นาทีใช้ fps=1/3
ffmpeg -v error -y -pattern_type glob -i "$W/frames/t_*.jpg" -vf "scale=640:-1,tile=4x4" $W/sheet_%02d.jpg
```

frame ที่ `t_NNN.jpg` อยู่ที่วินาที `(NNN-1) × 2`

## ขั้นตอน

1. อ่าน contact sheet ก่อน เพื่อเข้าใจ flow รวม (มีกี่หน้าจอ, เปลี่ยน role หรือแท็บที่ไหน)
2. อ่าน frame เดี่ยวในจุดสำคัญ เก็บ:
   - URL ใน address bar
   - ชื่อเมนู ปุ่ม ฟิลด์ ตามที่ UI แสดงจริง
   - ค่าที่เลือกหรือกรอก
   - user / role ที่ login
   - error message, toast, HTTP status
   - ตำแหน่ง cursor ที่ click
3. **ข้อความเล็กหรือไอคอน ต้องซูมยืนยัน** (เช่น typo ที่ตัวอักษรคล้ายกัน, จุดสี, badge):
   ```bash
   ffmpeg -v error -y -ss <วินาที> -i "$V" -frames:v 1 $W/full.png
   python3 -c "
   from PIL import Image
   im=Image.open('$W/full.png')
   im.crop((x0,y0,x1,y1)).resize((w*3,h*3)).save('$W/zoom.png')"
   ```
   ถ้าซูมแล้วยังไม่ชัด ห้ามเขียนลง Actual Result
4. ช่วงที่เปลี่ยนเร็ว: `ffmpeg -ss <start> -to <end> -i "$V" -vf fps=2 ...`
5. จด timestamp ของจุดสำคัญ เช่น "วิดีโอ 0:10"
6. ถ้ามีเสียงพูด แจ้งผู้ใช้ว่าอ่านได้แค่ภาพ และถามว่ามีคำอธิบายสำคัญในเสียงไหม
7. หลาย role / หลายแท็บ: แยกส่วนเตรียมข้อมูลไปใน Precondition และแยก step ตาม role
8. ถ้าเห็นแค่บางกรณีของ bug (เช่น เห็นวันอาทิตย์ แต่ไม่เห็นวันเสาร์) ให้เขียน Actual เฉพาะที่เห็น แล้วแจ้งผู้ใช้
