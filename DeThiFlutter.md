# Đề thi lập trình Flutter ứng tuyển tại Techmaster

Đây là đề thi dành cho thực tập sinh Flutter muốn [tham gia dự án ứng dụng di động học trực tuyến ](https://techmaster.vn/posts/38275/techmaster-tuyen-sinh-vien-thuc-tap-mobile-flutter-c-va-ai-2025).

Mục tiêu đề thi để đánh giá khả năng tìm kiếm giải pháp, xử lý vấn đề của sinh viên hơn là kiểm tra kỹ năng lập trình giao diện di động (giờ AI đã làm hộ rất nhiều rồi). Đề thi gồm có nhiều bài từ dễ đến khó để sinh viên luyện tập dần. Thời gian lập trình trong 7 ngày. Hãy tích cực hỏi ChatGPT hoặc Claude Sonnet để tìm giải pháp.

## Hướng dẫn làm và nộp bài

1. Cứ mạnh dạn hỏi ChatGPT và Claude Sonnet.
2. Tạo một github repo trên github chia thành các thư mục 01, 02, 03, 04, 05 để đánh số các bài.
3. Làm được càng nhiều càng tốt nhưng không nhất thiết tất cả các bài.
4. Trong lúc làm khó gì cứ hỏi tôi (Cường ở số Zalo 0902209011)
5. Trong mỗi thư mục lưu một dự án Flutter giải quyết yêu cầu hãy viết file ReadMe.md chụp lại màn hình kết quả bạn đã làm và mô tả cách giải quyết của bạn hoặc prompt bạn đã hỏi AI để giải quyết

## Bài 1:

Hãy dùng Figma để thiết kế ứng dụng học tiếng Anh gồm từ mới, mẫu câu, hội thoại, quiz, flash card.
Chụp lại ảnh màn hình hoặc gửi đường link figma

## Bài 2:

Sử dụng thuật toán 8 quân hậu (đặt 8 quân hậu lên bàn cờ vua 8x8 sao cho không có hai quân hậu nào chiếu lẫn nhau. Điều này có nghĩa là không có hai quân hậu nào được nằm trên cùng một hàng, cột, hoặc đường chéo) viết bằng Dart để tìm tất cả các lời giải.

Tạo hàm hứng sự kiện người dùng quệt trái và phải để di chuyển giữa các lời giải.
![](8queens.png)

## Bài 3:

Hãy tham khảo video ví dụ highlight.mp4 để lập trình highlight phát âm một hội thoại. File âm thanh là jamesflora.wav
còn file đánh dấu thời điểm phát âm trong jamesflora.json. Thời gian được đo bằng millisecond.

```json
{
  "r": "James",
  "s": "Not bad! I was wondering if you’re free tonight. I was thinking we could have dinner at 6:00 and then catch a movie afterward.",
  "t0": 7575,   //thời điểm bắt đầu
  "t1": 14275,  //thời điểm kết thúc
  "b": 109,     //vị trí bắt đầu câu
  "e": 235      //vị trí kết thúc câu
}

[
  100,  //thời điểm bắt đầu
  250,  //thời điểm kết thúc
  "Hi",
  0,    //vị trí bắt đầu từ
  2     //độ dài từ
]
```

## Bài 4:

Lập trình xử lý đa chạm để vẽ một tam giác có 3 đỉnh. Người dùng có thể chạm vào từng đỉnh để di chuyển vẽ lại tam giác
![](triangle.png)
