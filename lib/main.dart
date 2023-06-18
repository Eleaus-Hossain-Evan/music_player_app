// ignore_for_file: unused_local_variable, unused_field

import 'package:atomsbox/atomsbox.dart';
import 'package:audio_handler/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/repositories/song_repository.dart';

import 'ui/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AudioHandler audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId:
          'com.example.music_player_app.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  runApp(MyApp(audioHandler: audioHandler));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required AudioHandler audioHandler})
      : _audioHandler = audioHandler;

  final AudioHandler _audioHandler;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SongRepository>(
          create: (context) => SongRepository(audioHandler: _audioHandler),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
