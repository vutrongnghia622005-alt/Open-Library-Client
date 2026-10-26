import 'package:open_library_client/core/l10n/app_strings.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/book_cover.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../books/models/book.dart';
import '../books/services/offline_book_library.dart';
import '../books/services/sample_books.dart';
import '../bookshelf/bookshelf_service.dart';
import '../books/services/open_library_service.dart';
import 'widgets/search_filters.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.service,
    required this.onBookTap,
    this.initialQuery = '',
    this.bookshelfService,
    this.showPreviewNavigation = false,
  });
  final OpenLibraryService service;
  final BookshelfService? bookshelfService;
  final ValueChanged<Book> onBookTap;
  final String initialQuery;
  final bool showPreviewNavigation;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final _query = TextEditingController(text: widget.initialQuery);
  Timer? _debounce;
  List<Book> _books = [];
  String? _language;
  BookSort _sort = BookSort.relevance;
  String? _error;
  int _generation = 0;
  int _page = 0;
  int _total = 0;
  bool _loading = false;
  bool _inFlight = false;
  bool _queued = false;
  bool _hasMore = false;
  bool _offlineOnly = false;
  String _searchType = 'books';
  String? _yearRange;
  bool _borrowableOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.trim().isNotEmpty) _restart();
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      _query.text = widget.initialQuery;
      _restart();
    }
  }

  void _restart({bool debounce = false}) {
    _debounce?.cancel();
    _generation++;
    _queued = false;
    setState(() {
      _books = [];
      _page = 0;
      _total = 0;
      _error = null;
      _hasMore = false;
      _loading = _offlineOnly || _query.text.trim().isNotEmpty;
    });
    if (!_loading) return;
    if (debounce) {
      _debounce = Timer(
        const Duration(milliseconds: 450),
        _offlineOnly ? _loadOffline : _load,
      );
    } else {
      if (_offlineOnly) {
        _loadOffline();
      } else {
        _load();
      }
    }
  }

  Future<void> _loadOffline() async {
    final generation = _generation;
    try {
      final catalog = await SampleBooks.load();
      final query = _query.text.trim().toLowerCase();
      final books = catalog
          .where(OfflineBookLibrary.hasBook)
          .where(
            (book) =>
                query.isEmpty ||
                book.title.toLowerCase().contains(query) ||
                book.authorLabel.toLowerCase().contains(query),
          )
          .toList();
      if (!mounted || generation != _generation || !_offlineOnly) return;
      setState(() {
        _books = books;
        _total = books.length;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || generation != _generation || !_offlineOnly) return;
      setState(() {
        _error = 'Không thể tải sách offline. Vui lòng thử lại.';
        _loading = false;
      });
    }
  }

  Future<void> _load() async {
    if (_query.text.trim().isEmpty) return;
    if (_inFlight) {
      if (_page == 0) _queued = true;
      return;
    }
    _inFlight = true;
    final generation = _generation;
    final page = _page + 1;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.service.searchBooks(
        query: _query.text.trim(),
        language: _language,
        sort: _sort,
        page: page,
      );
      if (!mounted || generation != _generation) return;
      final ids = _books.map((book) => book.id).toSet();
      final filtered = result.books.where((book) {
        if (_yearRange == null) return true;
        final year = book.firstPublishYear;
        if (year == null) return false;
        final bounds = _yearRange!.split('-');
        if (bounds.length != 2) return true;
        final from = int.tryParse(bounds[0]);
        final to = int.tryParse(bounds[1]);
        return (from == null || year >= from) && (to == null || year <= to);
      });
      setState(() {
        _books = [..._books, ...filtered.where((book) => ids.add(book.id))];
        _page = page;
        _total = result.total;
        _hasMore = result.hasMore;
      });
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(
        () => _error = error is BookSearchException
            ? error.message
            : 'Không thể tìm sách. Vui lòng thử lại.',
      );
    } finally {
      _inFlight = false;
      if (mounted) {
        if (generation == _generation) setState(() => _loading = false);
        if (_queued) {
          _queued = false;
          _load();
        }
      }
    }
  }

  final Set<String> _saving = {};

  Future<void> _saveBook(Book book) async {
    final shelf = widget.bookshelfService;
    if (shelf == null) {
      widget.onBookTap(book);
      return;
    }
    if (_saving.contains(book.id)) return;
    setState(() => _saving.add(book.id));
    try {
      final added = await shelf.addBook(book);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              added
                  ? context.tr("Đã thêm sách vào tủ.")
                  : context.tr("Sách đã có trong tủ."),
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr("Chưa lưu được sách. Vui lòng thử lại.")),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving.remove(book.id));
    }
  }

  Widget _bookCard(Book book) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    Widget card() => Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => widget.onBookTap(book),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: BookCover(book: book, width: 56, height: 78),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('${book.authorLabel}${book.firstPublishYear == null ? '' : ' · ${book.firstPublishYear}'}',
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: muted)),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _statusChip('Chi tiết sách', const Color(0xFFE4F3EB), const Color(0xFF176C55)),
                  if (widget.bookshelfService?.bookById(book.id) != null)
                    _statusChip('Đã lưu', const Color(0xFFF1F1F5), muted),
                ]),
              ],
            )),
            if (widget.bookshelfService != null)
              IconButton(
                tooltip: 'Lưu vào kệ sách',
                onPressed: _saving.contains(book.id) ? null : () => _saveBook(book),
                icon: Icon(widget.bookshelfService!.bookById(book.id) != null
                  ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: const Color(0xFF176C55), size: 21),
              ),
          ]),
        ),
      ),
    );
    final shelf = widget.bookshelfService;
    return shelf == null ? card() :
      ListenableBuilder(listenable: shelf, builder: (_, _) => card());
  }

  Widget _statusChip(String label, Color background, Color foreground) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background,
        borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, color: foreground,
        fontWeight: FontWeight.w600)),
    );

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    const green = Color(0xFF176C55);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
        ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface : const Color(0xFFF7F7FA),
        child: Column(children: [
          Expanded(child: ListView(
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SafeArea(bottom: false, child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  IconButton(
                    tooltip: 'Quay lại',
                    onPressed: () {
                      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.chevron_left_rounded, size: 24),
                  ),
                  Expanded(child: SizedBox(height: 42, child: TextField(
                    controller: _query,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => _restart(debounce: true),
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      _restart();
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tên sách, tác giả, ISBN...',
                      hintStyle: TextStyle(fontSize: 12, color: muted),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _query.text.isEmpty ? null : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () { _query.clear(); _restart(); },
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: green)),
                    ),
                  ))),
                ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    for (final tab in const [
                      ('books', 'Sách'), ('authors', 'Tác giả'), ('subjects', 'Chủ đề')
                    ]) Expanded(child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() => _searchType = tab.$1);
                        if (tab.$1 != 'books') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đang tìm kiếm sách theo từ khóa. Tìm riêng tác giả/chủ đề cần cập nhật API.')),
                          );
                        }
                        _restart();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _searchType == tab.$1 ?
                            theme.colorScheme.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _searchType == tab.$1 ?
                            [const BoxShadow(color: Color(0x14000000), blurRadius: 5)] : null,
                        ),
                        child: Text(tab.$2, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,
                            fontWeight: _searchType == tab.$1 ?
                              FontWeight.w700 : FontWeight.w400,
                            color: _searchType == tab.$1 ? green : muted)),
                      ),
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
                SearchFilters(
                  language: _language, sort: _sort,
                  borrowableOnly: _borrowableOnly,
                  yearRange: _yearRange,
                  onLanguageChanged: (v) { _language = v; _restart(); },
                  onSortChanged: (v) { _sort = v; _restart(); },
                  onBorrowableChanged: (v) {
                    setState(() => _borrowableOnly = v);
                    if (v) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã bật dấu tích. Lọc sách có thể mượn cần hỗ trợ API.')),
                      );
                    }
                  },
                  onYearRangeChanged: (v) { _yearRange = v; _restart(); },
                ),
                const SizedBox(height: 8),
                // Retain the existing offline feature without confusing it with borrowing.
                Row(children: [
                  SizedBox(height: 30, child: FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: const Text('Đọc offline', style: TextStyle(fontSize: 11)),
                    selected: _offlineOnly,
                    onSelected: (v) { setState(() => _offlineOnly = v); _restart(); },
                  )),
                ]),
              ]),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (_query.text.trim().isEmpty && !_offlineOnly)
                  const _SearchMessage(icon: Icons.manage_search_rounded,
                    text: 'Nhập tên sách, tác giả hoặc chủ đề để tìm kiếm.')
                else ...[
                  Row(children: [
                    Expanded(child: Text(
                      _offlineOnly ? 'Sách đọc offline' :
                        'Kết quả cho “${_query.text.trim()}”',
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: muted),
                    )),
                    if (!_loading) Text('$_total kết quả',
                      style: TextStyle(fontSize: 11, color: muted)),
                  ]),
                  const SizedBox(height: 12),
                  for (final book in _books)
                    Padding(padding: const EdgeInsets.only(bottom: 9),
                      child: _bookCard(book)),
                  if (_loading) const LoadingView()
                  else if (_error != null)
                    ErrorView(message: _error!,
                      onRetry: _offlineOnly ? _loadOffline : _load)
                  else if (_books.isEmpty)
                    const _SearchMessage(icon: Icons.search_off_rounded,
                      text: 'Không tìm thấy sách. Hãy thử từ khóa hoặc bộ lọc khác.')
                  else if (_hasMore)
                    OutlinedButton.icon(onPressed: _load,
                      icon: const Icon(Icons.expand_more_rounded),
                      label: const Text('Tải thêm')),
                ],
              ]),
            ),
          ],
        )),
        if (widget.showPreviewNavigation)
          _PreviewBottomNavigation(),
        ]),
      ),
    );
  }
}

class _PreviewBottomNavigation extends StatelessWidget {
  const _PreviewBottomNavigation();

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF176C55);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    const items = [
      (Icons.explore_outlined, 'Khám phá'),
      (Icons.search_rounded, 'Tìm kiếm'),
      (Icons.menu_book_outlined, 'Kệ sách'),
      (Icons.person_outline_rounded, 'Tài khoản'),
    ];
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (i != 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đây là bản xem trước Search. Mục ${items[i].$2} sẽ được nối với điều hướng chính của ứng dụng.')),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(items[i].$1, size: 24, color: i == 1 ? green : muted),
                          const SizedBox(height: 4),
                          Text(items[i].$2, style: TextStyle(
                            fontSize: 11,
                            fontWeight: i == 1 ? FontWeight.w700 : FontWeight.w500,
                            color: i == 1 ? green : muted,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Column(children: [
      Icon(icon, size: 44, color: const Color(0xFF176C55)),
      const SizedBox(height: 12),
      Text(text, textAlign: TextAlign.center),
    ]),
  );
}
