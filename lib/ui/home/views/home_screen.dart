import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/song.dart';
import '../../../repositories/song_repository.dart';
import '../../widgets/music_player/music_player.dart';

part 'widgets/_trending_songs_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppText.headlineSmall('Good evening!'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const MusicPlayer(dense: true),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TrendingSongsSection(),
              // MusicPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}
