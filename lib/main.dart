// ignore_for_file: unused_local_variable, unused_field

import 'package:atomsbox/atomsbox.dart';
import 'package:audio_handler/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'ui/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AudioHandler audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(),
  );
  runApp(MyApp(audioHandler: audioHandler));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required AudioHandler audioHandler})
      : _audioHandler = audioHandler;

  final AudioHandler _audioHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
