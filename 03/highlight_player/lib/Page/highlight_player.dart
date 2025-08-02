import 'package:flutter/material.dart';
import 'package:highlight_player/Page/controller.dart';
import 'package:just_audio/just_audio.dart';

class HighlightPlayer extends StatefulWidget {
  const HighlightPlayer({super.key});

  @override
  State<HighlightPlayer> createState() => _HighlightPlayerState();
}

class _HighlightPlayerState extends State<HighlightPlayer> {
  late AudioPlayer _audioPlayer;
  late HighlightController _highlightController;
  Duration audioDuration = Duration.zero;
  bool dataLoaded = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _highlightController = HighlightController();
    _init();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    // Đăng ký stream này sau khi data đã load xong
  }

  Future<void> _init() async {
    await _highlightController.loadData('assets/jamesflora.json');
    await _audioPlayer.setAsset('assets/jamesflora.wav');
    audioDuration = await _audioPlayer.load() ?? Duration.zero;
    _audioPlayer.positionStream.listen((pos) {
      _highlightController.updateHighlight(pos.inMilliseconds);
    });
    _highlightController.addListener(() => setState(() {}));
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _highlightController.dispose();
    super.dispose();
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
        child: dataLoaded
            ? Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _highlightController.buildSentence(),
                    const Expanded(flex: 1, child: SizedBox()),
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
                    const SizedBox(height: 24),
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
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
      ),
    );
  }
}
