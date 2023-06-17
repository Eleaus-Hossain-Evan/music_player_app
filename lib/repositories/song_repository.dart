import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

class SongRepository {
  SongRepository({required AudioHandler audioHandler})
      : _audioHandler = audioHandler;

  final AudioHandler _audioHandler;

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MusicPlayerData> get musicPlayerDataStream => Rx.combineLatest4<
              PlaybackState,
              List<MediaItem>,
              MediaItem?,
              Duration,
              MusicPlayerData>(_audioHandler.playbackState, _audioHandler.queue,
          _audioHandler.mediaItem, AudioService.position, (
        PlaybackState playbackState,
        List<MediaItem> queue,
        MediaItem? mediaItem,
        Duration position,
      ) {
        return MusicPlayerData(
          currentSong:
              (mediaItem == null) ? null : Song.fromMediaItem(mediaItem),
          songQueue: queue.map((mediaItem) {
            return Song.fromMediaItem(mediaItem);
          }).toList(),
          playbackState: playbackState,
          currentSongPosition: position,
          currentSongDuration: (mediaItem == null) ? null : mediaItem.duration,
        );
      });

  Future<void> setCurrentSong(Song song) async {
    _audioHandler.removeQueueItemAt(0);
    _audioHandler.addQueueItem(song.toMediaItem());
  }
}
