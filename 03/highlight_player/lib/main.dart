import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HighlightPlayer(),
    );
  }
}

class HighlightPlayer extends StatefulWidget {
  const HighlightPlayer({super.key});

  @override
  State<HighlightPlayer> createState() => _HighlightPlayerState();
}

class _HighlightPlayerState extends State<HighlightPlayer> {
  late AudioPlayer _audioPlayer;
  List<dynamic> sentences = [];
  List<dynamic> words = [];
  int currentSentenceIdx = 0;
  int? highlightedWordIdx;
  Duration audioDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    loadData();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    _audioPlayer.positionStream.listen((pos) {
      updateHighlight(pos.inMilliseconds);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    // Đổi đường dẫn nếu cần, hoặc đọc file assets
    final jsonStr = await rootBundle.loadString('assets/jamesflora.json');
    final jsonData = json.decode(jsonStr);
    setState(() {
      sentences = jsonData['sentence'];
      words = jsonData['word'];
    });
    await _audioPlayer.setAsset('assets/jamesflora.wav');
    audioDuration = await _audioPlayer.load() ?? Duration.zero;
  }

  void updateHighlight(int ms) {
    // Xác định câu đang phát
    int? sentenceIdx;
    for (var i = 0; i < sentences.length; i++) {
      final s = sentences[i];
      if (ms >= s['t0'] && ms <= s['t1']) {
        sentenceIdx = i;
        break;
      }
    }
    if (sentenceIdx == null) {
      setState(() {
        currentSentenceIdx = 0;
        highlightedWordIdx = null;
      });
      return;
    }
    // Xác định từ đang phát
    final s = sentences[sentenceIdx];
    int? wordIdx;
    for (var i = 0; i < words.length; i++) {
      final w = words[i];
      if (w[0] <= ms && ms <= w[0] + w[1] && w[3] >= s['b'] && w[3] < s['e']) {
        wordIdx = i;
        break;
      }
    }
    setState(() {
      currentSentenceIdx = sentenceIdx!;
      highlightedWordIdx = wordIdx;
    });
  }

  Widget buildSentence() {
    if (sentences.isEmpty || words.isEmpty) return const SizedBox();
    final s = sentences[currentSentenceIdx];
    // Tạo danh sách các TextSpan cho từng từ
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
          ),
        ),
      );
    }
    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(fontSize: 32, fontFamily: 'monospace'),
      ),
      textAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _audioPlayer.playerState.playing;
    final duration = audioDuration.inMilliseconds > 0
        ? audioDuration
        : const Duration(seconds: 1);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSentence(),
              const SizedBox(height: 40),
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final pos = snapshot.data ?? Duration.zero;
                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        value: pos.inMilliseconds
                            .clamp(0, duration.inMilliseconds)
                            .toDouble(),
                        onChanged: (v) => _audioPlayer.seek(
                          Duration(milliseconds: v.toInt()),
                        ),
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white24,
                      ),
                      Text(
                        "${(pos.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.white38),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 56,
                  color: Colors.orange,
                ),
                onPressed: () {
                  if (isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
