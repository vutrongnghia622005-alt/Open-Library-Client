import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../books/book_detail_page.dart';
import '../books/book_reading_page.dart';
import '../books/models/book.dart';
import '../books/services/offline_book_library.dart';
import '../books/services/open_library_service.dart';
import '../bookshelf/bookshelf_page.dart';
import '../bookshelf/reading_progress_sheet.dart';
import '../bookshelf/bookshelf_service.dart';
import '../bookshelf/models/saved_book.dart';
import '../discovers/discover_page.dart';
import '../discovers/widgets/reading_card.dart';
import '../profile/profile_page.dart';
import '../profile/settings_service.dart';
import '../search/search_page.dart';

/// Authenticated shell with discover/search and the existing account page.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.authService,
    this.service,
    this.readingBooks,
    this.onAddToShelf,
    this.bookshelfService,
    this.bookshelfFactory,
    this.settings,
  });
  final AuthService authService;
  final BookshelfService? bookshelfService;
  final BookshelfService Function(String userId)? bookshelfFactory;
  final OpenLibraryService? service;
  final Future<bool> Function(Book)? onAddToShelf;
  final ValueListenable<List<ReadingBook>>? readingBooks;
  final SettingsService? settings;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final _service = widget.service ?? OpenLibraryService();
  late final _shelf =
      widget.bookshelfService ??
      widget.bookshelfFactory?.call(widget.authService.currentUser!.id) ??
      BookshelfService(userId: widget.authService.currentUser!.id);
  late final _settings =
      widget.settings ??
      SettingsService(userId: widget.authService.currentUser!.id);
  @override
  void initState() {
    super.initState();
    _shelf.loadBooks();
    if (widget.settings == null) _settings.load();
  }

  bool _showNavigation = true;

  void _selectTab(int index) => setState(() {
    _tab = index;
    _showNavigation = true;
  });

  bool _onScroll(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical ||
        notification.direction == ScrollDirection.idle ||
        notification.metrics.maxScrollExtent <=
            notification.metrics.minScrollExtent) {
      return false;
    }
    final visible = notification.direction == ScrollDirection.forward;
    if (_showNavigation != visible) {
      setState(() => _showNavigation = visible);
    }
    return false;
  }

  int _tab = 0;
  String _query = '';

  @override
  void dispose() {
    if (widget.service == null) _service.dispose();
    if (widget.bookshelfService == null) _shelf.dispose();
    if (widget.settings == null) _settings.dispose();
    super.dispose();
  }

  void _openBook(Book book) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BookDetailPage(
        book: book,
        service: _service,
        settings: _settings,
        onAddToShelf: widget.onAddToShelf ?? _shelf.addBook,
        onStartReading: _markReading,
        onPageChanged: _saveReadingPage,
      ),
    ),
  );

  Future<void> _markReading(Book book) async {
    if (_shelf.bookById(book.id) == null) await _shelf.addBook(book);
    if (_shelf.bookById(book.id)?.status != ReadingStatus.reading) {
      await _shelf.updateStatus(book.id, ReadingStatus.reading);
    }
  }

  Future<void> _saveReadingPage(Book book, int page) async {
    if (_shelf.bookById(book.id) == null) await _markReading(book);
    final total = _shelf.bookById(book.id)?.totalPages;
    await _shelf.updateProgress(
      book.id,
      total == null ? page : page.clamp(1, total),
    );
  }

  Future<void> _openSavedBook(Book book) async {
    if (!OfflineBookLibrary.hasBook(book)) {
      _openBook(book);
      return;
    }
    try {
      await _markReading(book);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Chưa lưu được sách vào tủ. Bạn vẫn có thể đọc tiếp.',
            ),
          ),
        );
      }
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookReadingPage(
          book: book,
          settings: _settings,
          onPageChanged: _saveReadingPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _settings,
    builder: (context, _) => _build(context),
  );

  Widget _build(BuildContext context) {
    final user = widget.authService.currentUser;
    if (user == null) return const SizedBox.shrink();
    final english = _settings.language == 'en';
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScroll,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: IndexedStack(
              index: _tab,
              children: [
                DiscoverPage(
                  displayName: user.displayName,
                  avatarBytes: _settings.avatarBytes,
                  readingBooks: widget.readingBooks ?? _shelf.readingBooks,
                  bookshelfService: _shelf,
                  onBookTap: _openBook,
                  onUpdateProgress: (book) {
                    final saved = _shelf.bookById(book.id);
                    if (saved == null) {
                      _openBook(book);
                      return;
                    }
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      builder: (_) =>
                          ReadingProgressSheet(service: _shelf, saved: saved),
                    );
                  },
                  onProfileTap: () => _selectTab(3),
                  onSearch: (query) => setState(() {
                    _query = query;
                    _tab = 1;
                    _showNavigation = true;
                  }),
                ),
                SearchPage(
                  service: _service,
                  bookshelfService: _shelf,
                  initialQuery: _query,
                  onBookTap: _openBook,
                ),
                BookshelfPage(
                  service: _shelf,
                  libraryService: _service,
                  onExplore: () => _selectTab(0),
                  onBookTap: _openBook,
                  onReadTap: (book) => _openSavedBook(book),
                ),
                ProfilePage(
                  authService: widget.authService,
                  settings: _settings,
                  onShelfTap: () => _selectTab(2),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TweenAnimationBuilder<double>(
        tween: Tween(end: _showNavigation ? 1 : 0),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: value,
            child: IgnorePointer(
              ignoring: !_showNavigation,
              child: ExcludeSemantics(
                excluding: !_showNavigation,
                child: FractionalTranslation(
                  translation: Offset(0, 1 - value),
                  child: Opacity(opacity: value, child: child),
                ),
              ),
            ),
          ),
        ),
        child: _BottomNav(
          selectedIndex: _tab,
          onSelected: _selectTab,
          dark: dark,
          items: [
            _NavItem(
              Icons.home_outlined,
              Icons.home_rounded,
              english ? 'Explore' : 'Khám phá',
            ),
            _NavItem(
              Icons.search,
              Icons.search,
              english ? 'Search' : 'Tìm kiếm',
            ),
            _NavItem(
              Icons.library_books_outlined,
              Icons.library_books,
              english ? 'Bookshelf' : 'Tủ sách',
            ),
            _NavItem(
              Icons.person_outline,
              Icons.person,
              english ? 'Profile' : 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Flat bottom bar from the mockup: a soft tinted pill marks the active tab.
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.dark,
  });
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final idle = dark ? Colors.white70 : const Color(0xFF686B74);
    final indicator = dark ? const Color(0xFF4B2B35) : const Color(0xFFFFEEE9);
    final animate = !MediaQuery.disableAnimationsOf(context);
    return Material(
      color: scheme.surface,
      shape: Border(top: BorderSide(color: scheme.outlineVariant)),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _destination(
                    items[i],
                    selected: i == selectedIndex,
                    onTap: () => onSelected(i),
                    idle: idle,
                    indicator: indicator,
                    animate: animate,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destination(
    _NavItem item, {
    required bool selected,
    required VoidCallback onTap,
    required Color idle,
    required Color indicator,
    required bool animate,
  }) {
    final color = selected ? AppTheme.accent : idle;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Center(
          child: AnimatedContainer(
            duration: animate
                ? const Duration(milliseconds: 220)
                : Duration.zero,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minWidth: 64, minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? indicator : indicator.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? item.selectedIcon : item.icon,
                  size: 25,
                  color: color,
                ),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
