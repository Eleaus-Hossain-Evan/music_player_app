import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/models.dart';
import '../../../repositories/song_repository.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    super.key,
    this.onTap,
    this.dense = false,
  });

  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<SongRepository>().musicPlayerDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final musicPlayerData = snapshot.data as MusicPlayerData;
          AudioPlayerState audioPlayerState = AudioPlayerState.stopped;

          if (musicPlayerData.currentSong == null) {
            return const SizedBox();
          }

          if (musicPlayerData.playbackState.playing == true) {
            audioPlayerState = AudioPlayerState.playing;
          } else if (musicPlayerData.playbackState.playing == false) {
            audioPlayerState = AudioPlayerState.paused;
          }
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.lg,
            ),
            child: AppAudioCard.dense(
              songName: musicPlayerData.currentSong!.title,
              artistName: musicPlayerData.currentSong!.artist.name,
              imageUrl: musicPlayerData.currentSong!.imageUrl,
              songUrl: musicPlayerData.currentSong!.songUrl,
              audioPlayerState: audioPlayerState,
              play: () => context.read<SongRepository>().play(),
              pause: () => context.read<SongRepository>().pause(),
              position: musicPlayerData.currentSongPosition ?? Duration.zero,
              duration: musicPlayerData.currentSongDuration ?? Duration.zero,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
