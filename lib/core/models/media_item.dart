class MediaItem {
  final int? id;
  final String title;
  final String category;
  final int progress;
  final int totalLength;
  final String status; // 'active', 'completed', 'plan'

  const MediaItem({
    this.id,
    required this.title,
    required this.category,
    required this.progress,
    required this.totalLength,
    required this.status,
  });

  double get progressPercent =>
      totalLength > 0 ? (progress / totalLength).clamp(0.0, 1.0) : 0.0;

  String get progressLabel {
    switch (category) {
      case 'Books':
        return 'Page $progress / $totalLength';
      case 'Movies':
        return progress == 0 ? 'Not started' : (progress >= totalLength ? 'Watched' : 'Watching');
      default:
        return 'Episode $progress / $totalLength';
    }
  }

  MediaItem copyWith({
    int? id,
    String? title,
    String? category,
    int? progress,
    int? totalLength,
    String? status,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      totalLength: totalLength ?? this.totalLength,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'category': category,
        'progress': progress,
        'total_length': totalLength,
        'status': status,
      };

  factory MediaItem.fromMap(Map<String, dynamic> map) => MediaItem(
        id: map['id'] as int?,
        title: map['title'] as String,
        category: map['category'] as String,
        progress: map['progress'] as int,
        totalLength: map['total_length'] as int,
        status: map['status'] as String,
      );
}
