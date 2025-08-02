import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HighlightController extends ChangeNotifier {
  List<dynamic> sentences = [];
  List<dynamic> words = [];
  int currentSentenceIdx = 0;
  int? highlightedWordIdx;

  HighlightController();
  // Hàm tải dữ liệu, gọi từ widget
  Future<void> loadData(String jsonPath) async {
    final jsonStr = await rootBundle.loadString(jsonPath);
    final jsonData = json.decode(jsonStr);
    sentences = jsonData['sentence'];
    words = jsonData['word'];
    notifyListeners();
  }

  /// Cập nhật highlight dựa trên thời gian ms
  void updateHighlight(int ms) {
    int? sentenceIdx;
    for (var i = 0; i < sentences.length; i++) {
      final s = sentences[i];
      if (ms >= s['t0'] && ms <= s['t1']) {
        sentenceIdx = i;
        break;
      }
    }
    if (sentenceIdx == null) {
      currentSentenceIdx = 0;
      highlightedWordIdx = null;
      notifyListeners();
      return;
    }
    final s = sentences[sentenceIdx];
    int? wordIdx;
    for (var i = 0; i < words.length; i++) {
      final w = words[i];
      if (w[0] <= ms && ms <= w[0] + w[1] && w[3] >= s['b'] && w[3] < s['e']) {
        wordIdx = i;
        break;
      }
    }
    currentSentenceIdx = sentenceIdx;
    highlightedWordIdx = wordIdx;
    notifyListeners();
  }

  /// Trả về Widget RichText câu hiện tại với highlight từ
  Widget buildSentence({TextStyle? style}) {
    if (sentences.isEmpty || words.isEmpty) return const SizedBox();
    final s = sentences[currentSentenceIdx];
    List<InlineSpan> spans = [];
    for (int i = 0; i < words.length; i++) {
      final w = words[i];
      if (!(w[3] >= s['b'] && w[3] < s['e'])) continue;
      final isHighlighted = (i == highlightedWordIdx);
      spans.add(
        TextSpan(
          text: w[2] + " ",
          style: TextStyle(
            color: isHighlighted ? Colors.black : Colors.white,
            backgroundColor: isHighlighted ? Colors.yellow : Colors.transparent,
            fontWeight: FontWeight.w600,
          ).merge(style),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: spans,
          style:
              style ?? const TextStyle(fontSize: 32, fontFamily: 'monospace'),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
