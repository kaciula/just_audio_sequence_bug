// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      if (sequenceState == null) return;

      // FIXME: Accessing the effective sequence after the long playlist has been replaced by the short playlist triggers Unhandled Exception: RangeError (index): Invalid value: Not in inclusive range 0..1: 2
      final List<IndexedAudioSource> effectiveSequence =
          sequenceState.effectiveSequence;
      print('effective sequence: $effectiveSequence');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(bottom: 48)),
                ElevatedButton(
                  onPressed: () {
                    _loadPlaylistAndPlay(longPlaylist);
                  },
                  child: Text('Play long playlist first'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                ),
                ElevatedButton(
                  onPressed: () {
                    _loadPlaylistAndPlay(shortPlaylist);
                  },
                  child: Text('Play short playlist second'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                ),
                ElevatedButton(
                  onPressed: () {
                    _player.stop();
                  },
                  child: Text('Stop audio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadPlaylistAndPlay(List<AudioSource> playlist) async {
    try {
      final ConcatenatingAudioSource playerPlaylist = ConcatenatingAudioSource(
        shuffleOrder: DefaultShuffleOrder(),
        children: playlist,
      );
      await _player.setAudioSource(playerPlaylist,
          initialIndex: 0, initialPosition: Duration.zero);
      await _player.setShuffleModeEnabled(true);
      _player.play();
    } catch (e) {
      print('Error loading audio source for playlist : $e');
    }
  }
}

final List<AudioSource> shortPlaylist = [
  AudioSource.uri(Uri.parse(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3')),
  AudioSource.uri(Uri.parse(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3')),
];

final List<AudioSource> longPlaylist = [
  AudioSource.uri(Uri.parse(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3')),
  AudioSource.uri(Uri.parse(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3')),
  AudioSource.uri(Uri.parse(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3')),
];
