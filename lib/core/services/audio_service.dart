import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String assetName) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$assetName'));
    } catch (_) {}
  }

  Future<void> tick() => play('ui_tick.wav');
  Future<void> progressPop() => play('progress_pop.wav');
  Future<void> completionChime() => play('completion_chime.wav');
  Future<void> addItem() => play('add_item.wav');
  Future<void> deleteItem() => play('delete_item.wav');
  Future<void> swipeAction() => play('swipe_action.wav');
  Future<void> tabSwitch() => play('tab_switch.wav');
  Future<void> milestone() => play('milestone.wav');
}
