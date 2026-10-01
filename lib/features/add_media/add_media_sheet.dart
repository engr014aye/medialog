import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/media_item.dart';
import '../../core/providers/media_provider.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/spring_animated_widget.dart';

const _categories = ['Movies', 'TV Shows', 'Anime', 'Books', 'Video Games'];

const _catColors = {
  'Movies': Color(0xFFEC4899),
  'TV Shows': Color(0xFF3B82F6),
  'Anime': Color(0xFFF59E0B),
  'Books': Color(0xFF10B981),
  'Video Games': Color(0xFFEF4444),
};

class AddMediaSheet extends ConsumerStatefulWidget {
  const AddMediaSheet({super.key});

  @override
  ConsumerState<AddMediaSheet> createState() => _AddMediaSheetState();
}

class _AddMediaSheetState extends ConsumerState<AddMediaSheet> {
  final _titleCtrl = TextEditingController();
  final _totalCtrl = TextEditingController(text: '12');
  String _category = 'TV Shows';
  String _status = 'active';
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }

  String get _totalLabel {
    switch (_category) {
      case 'Books': return 'Total Pages';
      case 'Movies': return 'Duration (min)';
      default: return 'Total Episodes';
    }
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    final total = int.tryParse(_totalCtrl.text) ?? 1;
    setState(() => _saving = true);
    final item = MediaItem(
      title: _titleCtrl.text.trim(),
      category: _category,
      progress: 0,
      totalLength: total.clamp(1, 99999),
      status: _status,
    );
    await ref.read(mediaListProvider.notifier).add(item);
    HapticFeedback.mediumImpact();
    await AudioService.instance.addItem();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      height: screenH * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Text('Add Media',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        )),
                const Spacer(),
                SpringTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Title'),
                  const SizedBox(height: 8),
                  _textField(_titleCtrl, 'Movie, show, book name...'),
                  const SizedBox(height: 20),
                  _label('Category'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final selected = _category == cat;
                      final color = _catColors[cat] ?? const Color(0xFF8B5CF6);
                      return SpringTap(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _category = cat);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: selected ? color : color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: selected ? Colors.white : color,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _label(_totalLabel),
                  const SizedBox(height: 8),
                  _textField(_totalCtrl, 'e.g. 12',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _label('Status'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _statusChip('active', 'Active / Watching'),
                      const SizedBox(width: 8),
                      _statusChip('plan', 'Plan to Watch'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SpringTap(
                    onTap: _saving ? null : _save,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : const Text('Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: 0.2,
            ),
      );

  Widget _textField(TextEditingController ctrl, String hint,
      {TextInputType? keyboardType}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.5),
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _statusChip(String value, String label) {
    final selected = _status == value;
    return Expanded(
      child: SpringTap(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _status = value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF8B5CF6).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF8B5CF6),
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
