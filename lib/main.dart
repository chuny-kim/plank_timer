
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const PlankTimerApp());

class PlankTimerApp extends StatelessWidget {
  const PlankTimerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plank Timer',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Duration _initial = const Duration(minutes: 1);
  Duration _remaining = const Duration(minutes: 1);
  Timer? _ticker;
  bool _running = false;
  final _player = AudioPlayer();

  void _start() {
    if (_running) return;
    setState(() => _running = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 1) {
        _finish();
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  void _pause() {
    _ticker?.cancel();
    setState(() => _running = false);
  }

  void _reset() {
    _pause();
    setState(() => _remaining = _initial);
  }

  void _finish() async {
    _pause();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 400, 200, 400]);
    }
    _player.play(AssetSource('sounds/ding.mp3'));
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('완료!'),
        content: const Text('플랭크 세트를 끝냈어요.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
      '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final percent =
        1 - (_remaining.inSeconds / _initial.inSeconds.clamp(1, double.infinity));
    return Scaffold(
      appBar: AppBar(title: const Text('Plank Timer')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: percent,
                        strokeWidth: 10,
                      ),
                    ),
                    Text(
                      _fmt(_remaining),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Slider(
              min: 10,
              max: 600,
              divisions: 59,
              value: _initial.inSeconds.toDouble(),
              label: '${_initial.inSeconds}s',
              onChanged: _running
                  ? null
                  : (v) => setState(() {
                        _initial = Duration(seconds: v.round());
                        _remaining = _initial;
                      }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: _running ? _pause : _start,
                  icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                  label: Text(_running ? 'Pause' : 'Start'),
                ),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _player.dispose();
    super.dispose();
  }
}
