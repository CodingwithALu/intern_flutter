# queens_app

Ứng dụng Flutter trực quan cho bài toán 8 quân hậu (Eight Queens Puzzle).

[![Giao diện ứng dụng](image_solve.png)](image_solve.png)

## Mô tả bài toán

Bài toán 8 quân hậu yêu cầu đặt 8 quân hậu lên bàn cờ vua 8x8 sao cho không có hai quân hậu nào chiếu lẫn nhau, tức là không có hai quân hậu nào nằm cùng hàng, cùng cột hoặc cùng đường chéo.

## Cách giải quyết

Ứng dụng sử dụng thuật toán **quay lui (backtracking)** để tìm tất cả các lời giải hợp lệ. Thuật toán sẽ thử đặt từng quân hậu ở mỗi hàng, kiểm tra điều kiện an toàn (không trùng cột, không trùng chéo). Khi đặt thành công 8 quân hậu, lời giải sẽ được lưu lại.

- Hàm giải quyết (`solveNQueens`) được tách riêng vào file `solve_queens.dart` để dễ quản lý.
- Giao diện chính (`EightQueensPage`) cho phép vuốt trái/phải để xem lần lượt từng lời giải khác nhau.
- Bàn cờ được xây dựng bằng `GridView`, mỗi lời giải sẽ được trực quan hóa với quân hậu đặt đúng vị trí.

## Chi tiết thuật toán quay lui giải bài toán N Quân Hậu (`solveNQueens`)

**Ý tưởng:**  
- Sử dụng một mảng `board`, trong đó `board[row] = col` nghĩa là ở hàng `row` đặt quân hậu tại cột `col`.
- Đệ quy qua từng hàng, thử đặt quân hậu vào mỗi cột một cách hợp lệ.

**Bước thực hiện:**
1. Bắt đầu từ hàng đầu tiên (row = 0).
2. Với mỗi cột ở hàng hiện tại, kiểm tra có an toàn không:
   - Không trùng cột với các hàng trước.
   - Không trùng đường chéo chính và phụ với các quân trước đó.
3. Nếu an toàn, đặt quân hậu ở vị trí đó rồi tiếp tục đệ quy sang hàng tiếp theo (`row + 1`).
4. Nếu đã đặt đủ N quân hậu (`row == n`), lưu lại lời giải bằng `result.add(List.from(board))`.
5. Nếu không còn vị trí hợp lệ, quay lui để thử vị trí khác ở hàng trước đó.

**Hàm kiểm tra an toàn (`isSafe`):**
- Kiểm tra xem cột mới (`col`) có trùng với bất kỳ cột của các hàng trước đó hay không (`board[i] == col`).
- Kiểm tra hai điều kiện đường chéo:
    - Cùng đường chéo chính: `board[i] - i == col - row`
    - Cùng đường chéo phụ: `board[i] + i == col + row`
- Nếu một trong các điều kiện trên đúng, trả về `false`, ngược lại trả về `true`.

**Hàm giải quyết (`solve`):**
- Nếu đã đặt xong N quân hậu (`row == n`), lưu lại lời giải.
- Thử từng cột ở hàng hiện tại, nếu hợp lệ thì tiếp tục đệ quy.
- Sau khi thử xong, đưa vị trí vừa đặt về trạng thái chưa đặt (`board[row] = -1`) để phục vụ cho nhánh quay lui.

**Ví dụ về một lời giải:**
```
[0, 4, 7, 5, 2, 6, 1, 3]
```
Nghĩa là:
- Hàng 0 đặt ở cột 0
- Hàng 1 đặt ở cột 4
- ...
- Hàng 7 đặt ở cột 3

## Chức năng nổi bật

- Xem tất cả các lời giải hợp lệ cho bài toán 8 quân hậu.
- Giao diện vuốt trái/phải chuyển lời giải trực quan.
- Màu bàn cờ và quân hậu dễ nhìn, thích hợp cho học tập và trình diễn.