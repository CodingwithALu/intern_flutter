List<List<int>> solveNQueens(int n) {
  List<List<int>> result = [];
  List<int> board = List.filled(n, -1);

  bool isSafe(int row, int col) {
    for (int i = 0; i < row; i++) {
      if (board[i] == col ||
          (board[i] - i == col - row) ||
          (board[i] + i == col + row)) {
        return false;
      }
    }
    return true;
  }

  void solve(int row) {
    if (row == n) {
      result.add(List.from(board));
      return;
    }
    for (int col = 0; col < n; col++) {
      if (isSafe(row, col)) {
        board[row] = col;
        solve(row + 1);
        board[row] = -1;
      }
    }
  }

  solve(0);
  return result;
}

void main() {
  final List<List<int>> solutions = solveNQueens(4);
  print(solutions);
  print(solutions.length);
}
