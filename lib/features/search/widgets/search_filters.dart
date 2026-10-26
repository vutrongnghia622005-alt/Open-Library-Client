import 'package:flutter/material.dart';
import '../../books/services/open_library_service.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({
    super.key,
    required this.language,
    required this.sort,
    required this.onLanguageChanged,
    required this.onSortChanged,
    required this.borrowableOnly,
    required this.onBorrowableChanged,
    required this.yearRange,
    required this.onYearRangeChanged,
  });

  final String? language;
  final BookSort sort;
  final bool borrowableOnly;
  final String? yearRange;
  final ValueChanged<String?> onLanguageChanged;
  final ValueChanged<BookSort> onSortChanged;
  final ValueChanged<bool> onBorrowableChanged;
  final ValueChanged<String?> onYearRangeChanged;

  static const languages = <String, String>{
    'all': 'Mọi ngôn ngữ', 'vie': 'Tiếng Việt', 'eng': 'Tiếng Anh',
    'fre': 'Tiếng Pháp', 'ger': 'Tiếng Đức', 'spa': 'Tiếng Tây Ban Nha',
  };
  static const sorts = <BookSort, String>{
    BookSort.relevance: 'Liên quan nhất',
    BookSort.newest: 'Mới nhất',
    BookSort.oldest: 'Cũ nhất',
  };
  static const years = <String, String>{
    'all': 'Mọi năm', '2020-': 'Từ 2020', '2010-2019': '2010–2019',
    '2000-2009': '2000–2009', '1900-1999': '1900–1999',
    '-1899': 'Trước 1900',
  };

  @override
  Widget build(BuildContext context) {
    Widget popup<T>({
      required String title,
      required T selected,
      required Map<T, String> choices,
      required ValueChanged<T> onSelected,
    }) => PopupMenuButton<T>(
      tooltip: title,
      initialValue: selected,
      onSelected: onSelected,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => choices.entries.map((entry) =>
        CheckedPopupMenuItem<T>(
          value: entry.key,
          checked: entry.key == selected,
          child: Text(entry.value),
        ),
      ).toList(),
      child: _Pill(label: title, icon: Icons.keyboard_arrow_down_rounded,
        selected: false),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        InkWell(
          onTap: () => onBorrowableChanged(!borrowableOnly),
          borderRadius: BorderRadius.circular(20),
          child: _Pill(label: 'Có thể mượn',
            icon: borrowableOnly ? Icons.check_circle_rounded : Icons.circle_outlined,
            selected: borrowableOnly),
        ),
        const SizedBox(width: 8),
        popup<String>(
          title: language == null ? 'Ngôn ngữ' : languages[language] ?? 'Ngôn ngữ',
          selected: language ?? 'all', choices: languages,
          onSelected: (v) => onLanguageChanged(v == 'all' ? null : v),
        ),
        const SizedBox(width: 8),
        popup<String>(
          title: yearRange == null ? 'Năm XB' : years[yearRange] ?? 'Năm XB',
          selected: yearRange ?? 'all', choices: years,
          onSelected: (v) => onYearRangeChanged(v == 'all' ? null : v),
        ),
        const SizedBox(width: 8),
        popup<BookSort>(
          title: sort == BookSort.relevance ? 'Sắp xếp' : sorts[sort]!,
          selected: sort, choices: sorts, onSelected: onSortChanged,
        ),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.icon, required this.selected});
  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFFE2F3EB) : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: selected ? const Color(0xFFB5DDCC) :
        Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 15, color: selected ? const Color(0xFF176C55) : null),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
        color: selected ? const Color(0xFF176C55) : null)),
    ]),
  );
}
