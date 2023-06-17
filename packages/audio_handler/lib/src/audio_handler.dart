import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  final _songQueue = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  void _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_songQueue);
    } catch (err) {
      log(err.toString(), error: err);
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      updateTime: event.updateTime,
      repeatMode: {
        LoopMode.off: AudioServiceRepeatMode.none,
        LoopMode.one: AudioServiceRepeatMode.one,
        LoopMode.all: AudioServiceRepeatMode.all,
      }[_player.loopMode]!,
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;

      if (index == null || newQueue.isEmpty) return;

      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;

      if (index == null || playlist.isEmpty) return;

      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }

      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;

      if (sequence == null || sequence.isEmpty) return;

      final items = sequence.map((source) => source.tag as MediaItem).toList();
      queue.add(items);
    });
  }

  /// Starts or resumes the playback of the current audio item in the queue.
  /// If the playback is already in progress, this method has no effect.
  ///
  /// Returns: A Future<void> that completes when the playback has started or resumed.
  @override
  Future<void> play() => _player.play();

  /// Pauses the playback of the current audio item. If the playback is already
  /// paused or stopped, this method has no effect.
  ///
  /// Returns: A Future<void> that completes when the playback has been paused.
  @override
  Future<void> pause() => _player.pause();

  /// Seeks the playback position of the current audio item to the specified Duration position.
  /// This method allows for both forward and backward seeking. If the provided position is
  /// out of bounds (less than 0 or greater than the audio item's duration), the player
  /// will automatically adjust it within the valid range.
  ///
  /// Returns: A Future<void> that completes when the seek operation has been performed.
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  /// Stops the playback of the current audio item and resets the player position to
  /// the beginning of the item. If the playback is already stopped, this method has no effect.
  ///
  /// Returns: A Future<void> that completes when the playback has been stopped.
  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  /// Adds a new MediaItem to the end of the playback queue. The provided mediaItem
  /// must have a valid URI in its extras field. Once the item is added, the
  /// playback queue is updated.
  ///
  /// Returns: A Future<void> that completes when the MediaItem has been added
  /// to the playback queue.
  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    _songQueue.add(audioSource);

    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  /// Removes a MediaItem from the playback queue at the specified index. If the
  /// index is out of range, this method has no effect. Once the item is removed,
  /// the playback queue is updated.
  ///
  /// Returns: A Future<void> that completes when the MediaItem has been removed
  /// from the playback queue or when the index is out of range.
  @override
  Future<void> removeQueueItemAt(int index) async {
    if (_songQueue.length > index) {
      _songQueue.removeAt(index);

      final newQueue = queue.value..removeAt(index);
      queue.add(newQueue);
    }
  }

  /// Creates a UriAudioSource instance from the given MediaItem. It takes the MediaItem
  /// as input, extracts the audio URL from its extras field, and returns a new
  /// UriAudioSource with the audio URL and the MediaItem itself as the tag.
  ///
  /// Returns: A UriAudioSource object containing the audio URL and the MediaItem as the tag.
  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );
  }
}
