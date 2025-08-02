# Highlight Audio Player

Ứng dụng Flutter này phát audio và **highlight từ** tương ứng theo thời gian, phù hợp cho các ứng dụng luyện nghe, karaoke, hoặc học ngoại ngữ.

---

## Mô tả chức năng

- Phát file âm thanh từ assets.
- Hiển thị văn bản chia theo câu và từ, từ nào đang được phát sẽ được **bôi vàng**.
- Hiển thị thanh trượt (slider) để tua audio, nút play/pause.
- Dữ liệu từ/câu và thời gian phát được lấy từ file JSON (cấu trúc gồm danh sách câu và từ, mỗi phần tử có thông tin thời gian).

---

## Cách giải quyết bài toán

### 1. **Quản lý dữ liệu và trạng thái**
- Sử dụng một lớp `HighlightController` để:
  - Quản lý danh sách câu (`sentences`), từ (`words`).
  - Cung cấp hàm `loadData()` để đọc dữ liệu từ file JSON.
  - Cung cấp hàm `updateHighlight()` để xác định câu và từ nào cần highlight theo vị trí thời gian hiện tại của audio.
  - Cung cấp hàm `buildSentence()` để dựng widget văn bản với từ đang highlight.

### 2. **Đồng bộ audio và highlight**
- Sử dụng package [`just_audio`](https://pub.dev/packages/just_audio) để phát audio và lắng nghe dòng thời gian phát (`positionStream`).
- Mỗi khi vị trí phát thay đổi, gọi `updateHighlight(ms)` để cập nhật highlight.
- Widget lắng nghe thay đổi từ controller để tự động cập nhật UI.

### 3. **Giao diện người dùng**
- Hiển thị câu hiện tại với highlight từ bằng `RichText`.
- Hiển thị thanh slider đồng bộ với vị trí phát audio, cho phép tua.
- Nút Play/Pause điều khiển trực tiếp trạng thái phát.
- Giao diện tối, nổi bật phần từ đang được đọc.

---

## Luồng hoạt động

1. **Tải dữ liệu**: 
    - Đọc file JSON để lấy danh sách câu/từ và thông tin thời gian.
    - Tải file audio.

2. **Phát audio**: 
    - Khi người dùng bấm play, audio bắt đầu phát.
    - Vị trí phát hiện tại được cập nhật liên tục.

3. **Highlight động**: 
    - Theo vị trí thời gian, controller xác định câu và từ đang được phát, highlight từ đó trên giao diện.

4. **Tua hoặc dừng**: 
    - Người dùng có thể tua hoặc tạm dừng, highlight sẽ cập nhật tương ứng với vị trí mới.

---

## Cấu trúc dữ liệu JSON (ví dụ)

```json
{
  "sentence": [
    {"t0": 0, "t1": 3000, "b": 0, "e": 4},
    ...
  ],
  "word": [
    [0, 500, "Hello", 0],
    [500, 700, "world", 1],
    ...
  ]
}
```
- `sentence`: mỗi câu có thời gian bắt đầu (`t0`), kết thúc (`t1`), chỉ số bắt đầu/kết thúc từ (`b`, `e`).
- `word`: mỗi phần tử gồm `[thời gian bắt đầu, độ dài, từ, chỉ số trong văn bản]`.

---

## Sơ đồ hoạt động

```
AudioPlayer <--> HighlightController <--> UI (RichText, Slider, ...)

- AudioPlayer phát audio và gửi position
- HighlightController nhận position, xác định highlight
- UI lắng nghe controller và cập nhật giao diện
```

---
## Minh họa giao diện

[![Demo Highlight Audio Player](assets/demo_highlight_player.png)](assets/demo_highlight_player.png)

*Bấm vào ảnh để xem kích thước lớn hơn.*

---
## Video minh họa
![Demo video](assets/highlight_player.mp4)