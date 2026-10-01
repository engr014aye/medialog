import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/media_item.dart';
import '../../core/providers/media_provider.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/spring_animated_widget.dart';
import '../add_media/add_media_sheet.dart';

const _categories = ['All', 'Movies', 'TV Shows', 'Anime', 'Books', 'Video Games'];

const _catColors = {
  'All': Color(0xFF8B5CF6),
  'Movies': Color(0xFFEC4899),
  'TV Shows': Color(0xFF3B82F6),
  'Anime': Color(0xFFF59E0B),
  'Books': Color(0xFF10B981),
  'Video Games': Color(0xFFEF4444),
};

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredActiveMediaProvider);
    final selectedCat = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onAdd: () => _showAddSheet(context, ref)),
            _CategoryPills(selected: selectedCat),
            Expanded(
              child: filtered.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (items) => items.isEmpty
                    ? _EmptyState(category: selectedCat)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: items.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MediaCard(item: items[i]),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _AddFAB(onTap: () => _showAddSheet(context, ref)),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddMediaSheet(),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAdd;
  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MediaLog',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                    letterSpacing: -0.5,
                  )),
          Text('Track your watchlist',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  )),
        ],
      ),
    );
  }
}

class _CategoryPills extends ConsumerWidget {
  final String selected;
  const _CategoryPills({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          final isSelected = cat == selected;
          final color = _catColors[cat] ?? const Color(0xFF8B5CF6);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SpringTap(
              onTap: () {
                HapticFeedback.selectionClick();
                AudioService.instance.tick();
                ref.read(selectedCategoryProvider.notifier).set(cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MediaCard extends ConsumerWidget {
  final MediaItem item;
  const _MediaCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _catColors[item.category] ?? const Color(0xFF8B5CF6);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.heavyImpact();
        AudioService.instance.deleteItem();
        ref.read(mediaListProvider.notifier).delete(item.id!);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_categoryIcon(item.category), color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.progressLabel,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.5),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: item.progressPercent,
                        minHeight: 5,
                        backgroundColor: color.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SpringTap(
                scaleDown: 0.88,
                onTap: () async {
                  if (item.progress >= item.totalLength) return;
                  HapticFeedback.lightImpact();
                  final willComplete = item.progress + 1 >= item.totalLength;
                  willComplete
                      ? await AudioService.instance.completionChime()
                      : await AudioService.instance.progressPop();
                  ref.read(mediaListProvider.notifier).incrementProgress(item);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.progress >= item.totalLength
                        ? const Color(0xFF10B981)
                        : color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.progress >= item.totalLength
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Movies': return Icons.movie_outlined;
      case 'TV Shows': return Icons.tv_outlined;
      case 'Anime': return Icons.auto_awesome_outlined;
      case 'Books': return Icons.menu_book_outlined;
      case 'Video Games': return Icons.sports_esports_outlined;
      default: return Icons.play_circle_outline;
    }
  }
}

class _AddFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _AddFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SpringTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text('Add Media', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              fontSize: 15,
            )),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String category;
  const _EmptyState({required this.category});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 72,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18)),
          const SizedBox(height: 16),
          Text('Nothing here yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  )),
          const SizedBox(height: 6),
          Text(
            category == 'All'
                ? 'Tap + Add Media to get started'
                : 'No active $category items',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
          ),
        ],
      ),
    );
  }
}
