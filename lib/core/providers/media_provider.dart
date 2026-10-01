import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_service.dart';
import '../models/media_item.dart';

final mediaListProvider =
    AsyncNotifierProvider<MediaNotifier, List<MediaItem>>(MediaNotifier.new);

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

final filteredActiveMediaProvider = Provider<AsyncValue<List<MediaItem>>>((ref) {
  final all = ref.watch(mediaListProvider);
  final cat = ref.watch(selectedCategoryProvider);
  return all.whenData((items) {
    final active = items.where((i) => i.status == 'active').toList();
    if (cat == 'All') return active;
    return active.where((i) => i.category == cat).toList();
  });
});

final completedMediaProvider = Provider<AsyncValue<List<MediaItem>>>((ref) {
  final all = ref.watch(mediaListProvider);
  return all.whenData((items) => items.where((i) => i.status == 'completed').toList());
});

final plannedMediaProvider = Provider<AsyncValue<List<MediaItem>>>((ref) {
  final all = ref.watch(mediaListProvider);
  return all.whenData((items) => items.where((i) => i.status == 'plan').toList());
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void set(String cat) => state = cat;
}

class MediaNotifier extends AsyncNotifier<List<MediaItem>> {
  @override
  Future<List<MediaItem>> build() async {
    return DatabaseService.instance.getAllMedia();
  }

  Future<void> add(MediaItem item) async {
    await DatabaseService.instance.insertMedia(item);
    ref.invalidateSelf();
    await future;
  }

  Future<void> incrementProgress(MediaItem item) async {
    await DatabaseService.instance.incrementProgress(
      item.id!,
      item.progress,
      item.totalLength,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(int id) async {
    await DatabaseService.instance.deleteMedia(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateItem(MediaItem item) async {
    await DatabaseService.instance.updateMedia(item);
    ref.invalidateSelf();
    await future;
  }
}
