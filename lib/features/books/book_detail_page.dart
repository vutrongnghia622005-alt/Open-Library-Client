import 'package:open_library_client/core/l10n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/book_cover.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/theme/app_theme.dart';
import 'data/book_enrichment_data.dart';
import 'editions_page.dart';
import 'book_reading_page.dart';
import 'models/book.dart';
import 'services/open_library_service.dart';
import 'services/offline_book_library.dart';
import 'services/book_discussion_service.dart';
import '../profile/settings_service.dart';
import 'widgets/book_discussion_section.dart';
import 'widgets/edition_metadata.dart';

/// Basic handoff destination; editions and full work data belong to person 3.
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({
    super.key,
    required this.book,
    this.service,
    this.onAddToShelf,
    this.openLink,
    this.settings,
    this.onStartReading,
    this.onPageChanged,
    this.userId,
    this.displayName,
    this.discussionService,
  });
  final Book book;
  final OpenLibraryService? service;

  /// The bookshelf service returns true when added, false when the work exists.
  final Future<bool> Function(Book)? onAddToShelf;
  final Future<bool> Function(Uri)? openLink;
  final SettingsService? settings;
  final Future<void> Function(Book)? onStartReading;
  final Future<void> Function(Book book, int page)? onPageChanged;
  final String? userId;
  final String? displayName;
  final BookDiscussionService? discussionService;
  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late final _service = widget.service ?? OpenLibraryService();
  Book? _book;
  String? _error;
  bool _loading = false;
  bool _saving = false;
  bool _saved = false;
  Future<List<BookAuthor>>? _authors;
  CommunityRating? _rating;

  @override
  void initState() {
    super.initState();
    if (OfflineBookLibrary.hasBook(widget.book)) {
      _book = BookEnrichmentData.enrich(widget.book);
      if (_book!.ratingAverage != null) {
        _rating = CommunityRating(
          average: _book!.ratingAverage!,
          count: _book!.ratingCount ?? 0,
        );
      }
      _loadRatings(_book!.id);
    } else {
      _load();
    }
  }

  @override
  void dispose() {
    if (widget.service == null) _service.dispose();
    super.dispose();
  }

  Future<void> _loadRatings(String workId) async {
    try {
      final rating = await _service.getBookRatings(workId);
      if (mounted && rating != null) {
        setState(() => _rating = rating);
      }
    } catch (_) {
      // Keep existing rating or null
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      var book = await _service.getBookDetails(widget.book);
      book = BookEnrichmentData.enrich(book);
      if (mounted) {
        setState(() {
          _book = book;
          if (book.ratingAverage != null) {
            _rating = CommunityRating(
              average: book.ratingAverage!,
              count: book.ratingCount ?? 0,
            );
          }
        });
        _loadRatings(book.id);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is BookSearchException
              ? error.message
              : 'Không thể tải chi tiết sách. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _message(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.trError(message))));
    }
  }

  Future<void> _save() async {
    if (_saving || _book == null || widget.onAddToShelf == null) return;
    setState(() => _saving = true);
    try {
      final added = await widget.onAddToShelf!(_book!);
      if (mounted) setState(() => _saved = true);
      _message(added ? "Đã thêm sách vào tủ." : "Sách đã có trong tủ.");
    } catch (_) {
      _message("Không thể thêm sách. Vui lòng thử lại.");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openSource() async {
    try {
      final url = _book!.selectedEdition?.sourceUrl ?? _book!.sourceUrl;
      final opened = widget.openLink != null
          ? await widget.openLink!(url)
          : await launchUrl(url);
      if (!opened) _message("Không thể mở Open Library. Vui lòng thử lại.");
    } catch (_) {
      _message("Không thể mở Open Library. Vui lòng thử lại.");
    }
  }

  Future<void> _shareBook() async {
    if (_book == null) return;
    final url = _book!.selectedEdition?.sourceUrl ?? _book!.sourceUrl;
    final text = '${_book!.title} - ${_book!.authorLabel}\n$url';
    await Clipboard.setData(ClipboardData(text: text));
    _message("Đã sao chép liên kết sách vào bộ nhớ tạm.");
  }

  Future<void> _read(Book book) async {
    if (OfflineBookLibrary.hasBook(book) && widget.onStartReading != null) {
      try {
        await widget.onStartReading!(book);
      } catch (_) {
        _message("Chưa lưu được sách vào tủ. Bạn vẫn có thể đọc tiếp.");
      }
    }
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BookReadingPage(
          book: book,
          settings: widget.settings,
          onPageChanged: widget.onPageChanged,
        ),
      ),
    );
  }

  Future<void> _chooseEdition() async {
    final edition = await Navigator.push<BookEdition>(
      context,
      MaterialPageRoute(
        builder: (_) => EditionsPage(
          workId: _book!.id,
          service: _service,
          selectedEditionId: _book!.selectedEdition?.id,
        ),
      ),
    );
    if (!mounted || edition == null) return;
    setState(() => _book = _book!.withEdition(edition));
  }

  void _loadAuthors() => setState(
    () => _authors = _fetchAuthors(),
  );

  Future<List<BookAuthor>> _fetchAuthors() async {
    if (_book == null) return const [];
    final ids = _book!.authorIds;
    if (ids.isNotEmpty) {
      final list = <BookAuthor>[];
      for (final id in ids) {
        try {
          final author = await _service.getAuthor(id);
          list.add(author);
        } catch (_) {
          final fallback = BookEnrichmentData.getAuthorById(id);
          if (fallback != null) {
            list.add(fallback);
          } else {
            rethrow;
          }
        }
      }
      return list;
    }
    // Fallback if authorIds is empty: check curated author data by name
    final list = <BookAuthor>[];
    for (final name in _book!.authors) {
      final fallback = BookEnrichmentData.getAuthorByName(name);
      if (fallback != null) {
        list.add(fallback);
      } else {
        list.add(BookAuthor(id: '', name: name));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: AppBar(
      title: Text(
        context.tr("Chi tiết sách"),
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          tooltip: context.tr("Chia sẻ sách"),
          onPressed: _book == null ? null : _shareBook,
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          tooltip: _saved
              ? context.tr("Đã có trong tủ sách")
              : context.tr("Lưu vào tủ sách"),
          onPressed:
              _book == null ||
                  _loading ||
                  _saving ||
                  widget.onAddToShelf == null
              ? null
              : _save,
          icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
        ),
      ],
    ),
    body: _loading
        ? const LoadingView()
        : _error != null
        ? ListView(
            children: [ErrorView(message: _error!, onRetry: _load)],
          )
        : _book == null
        ? const SizedBox.shrink()
        : _content(_book!),
  );

  Widget _content(Book book) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0.0, 280.0);
            return Center(
              child: BookCover(
                book: book,
                width: width,
                height: width * 238 / 164,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        if (book.originalTitle != null &&
            book.originalTitle!.trim().isNotEmpty &&
            book.originalTitle!.trim() != book.title.trim())
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              context.tr("Tên gốc: {0}", [book.originalTitle!]),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          book.authors.isEmpty
              ? context.tr("Chưa có dữ liệu")
              : context.tr(book.authorLabel),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                book.selectedEdition?.pages == null
                    ? context.tr("Chưa có số trang")
                    : context.tr("{0} trang", [book.selectedEdition!.pages]),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (_rating != null && _rating!.count > 0) ...[
              const SizedBox(width: 14),
              const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 20),
              const SizedBox(width: 4),
              Text(
                _rating!.average.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                '(${_rating!.count > 1000 ? '${(_rating!.count / 1000).toStringAsFixed(1)}k' : _rating!.count})',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        if (book.categories.isEmpty)
          Text(context.tr("Thể loại: Chưa có dữ liệu"))
        else
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final category in book.categories.take(4))
                Chip(
                  label: Text(
                    context.tr(category),
                    style: const TextStyle(
                      color: Color(0xFFFF554C),
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFFEEE7),
                  side: BorderSide.none,
                ),
            ],
          ),
        if (book.quote != null && book.quote!.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2C2D3A)
                  : const Color(0xFFFFF7F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF713D).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: Color(0xFFFF713D),
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${book.quote!}"',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (book.authors.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          '— ${book.authors.first}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        if (book.subjectPeople.isNotEmpty ||
            book.subjectPlaces.isNotEmpty ||
            book.subjectTimes.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF343544)
                  : AppTheme.softSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr("Đặc điểm tác phẩm"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (book.subjectPeople.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 18,
                        color: Color(0xFFFF713D),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.tr("Nhân vật")}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: book.subjectPeople.join(', '),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (book.subjectPlaces.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFFFF713D),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.tr("Bối cảnh")}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: book.subjectPlaces.join(', '),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (book.subjectTimes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.history_outlined,
                        size: 18,
                        color: Color(0xFFFF713D),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.tr("Thời kỳ")}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: book.subjectTimes.join(', '),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF343544)
                : AppTheme.softSurface,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.language, size: 21),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tr("Ngôn ngữ ấn bản"),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        book.selectedEdition?.languageLabel.isNotEmpty == true
                            ? book.selectedEdition!.languageLabelFor(context.tr)
                            : context.tr("Chưa có dữ liệu"),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E6EC)),
              InkWell(
                onTap: _saving ? null : _chooseEdition,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 21),
                      const SizedBox(width: 12),
                      Text(
                        context.tr("Ấn bản"),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.tr("Xem các phiên bản"),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.tr("Giới thiệu"),
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SelectableText(
          context.tr(book.description ?? "Chưa có dữ liệu"),
          style: const TextStyle(fontSize: 15, height: 1.55),
        ),
        if (book.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              context.tr("Nguồn giới thiệu: {0}", [
                context.tr(book.descriptionSource ?? "Chưa có dữ liệu"),
              ]),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => _read(book),
          icon: const Icon(Icons.auto_stories_outlined),
          label: Text(context.tr("Đọc sách")),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF713D), Color(0xFFF03562)],
            ),
          ),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: widget.onAddToShelf == null || _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bookmark_add_outlined),
            label: Text(
              _saving
                  ? context.tr("Đang thêm…")
                  : context.tr("Thêm vào tủ sách"),
            ),
          ),
        ),
        // shortcut: saving is injected by person 4; enable when its persistent bookshelf service is available.
        if (widget.onAddToShelf == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              context.tr("Tính năng lưu sách chưa khả dụng."),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF554C),
            side: const BorderSide(color: Color(0xFFFF554C)),
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _openSource,
          icon: const Icon(Icons.open_in_new),
          label: Text(context.tr("Mở trên Open Library")),
        ),
        const SizedBox(height: 20),
        Text(
          context.tr("Thông tin xuất bản"),
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr("Xuất bản lần đầu: {0}", [
            book.firstPublishYear ?? context.tr("Chưa có dữ liệu"),
          ]),
        ),
        EditionMetadata(edition: book.selectedEdition),
        if (book.authorIds.isNotEmpty || book.authors.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(context.tr("Thông tin tác giả")),
            onExpansionChanged: (open) {
              if (open && _authors == null) _loadAuthors();
            },
            children: [
              if (_authors != null)
                FutureBuilder<List<BookAuthor>>(
                  future: _authors,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingView();
                    }
                    if (snapshot.hasError) {
                      return ErrorView(
                        message: context.tr("Không thể tải thông tin tác giả."),
                        onRetry: _loadAuthors,
                      );
                    }
                    final authors = snapshot.data ?? const [];
                    if (authors.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(context.tr("Chưa có dữ liệu")),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final author in authors)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: const Color(0xFFFFEEE7),
                                      backgroundImage: author.photoUrl != null
                                          ? NetworkImage(author.photoUrl!)
                                          : null,
                                      child: author.photoUrl == null
                                          ? const Icon(
                                              Icons.person,
                                              color: Color(0xFFFF554C),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            author.name ??
                                                context.tr("Chưa có dữ liệu"),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (author.birthDate != null)
                                            Text(
                                              context.tr("Ngày sinh: {0}", [
                                                author.birthDate,
                                              ]),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          if (author.deathDate != null)
                                            Text(
                                              context.tr("Ngày mất: {0}", [
                                                author.deathDate,
                                              ]),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  author.biography ??
                                      context.tr("Chưa có dữ liệu"),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const Divider(height: 20),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        if (widget.userId != null && widget.displayName != null) ...[
          const SizedBox(height: 28),
          BookDiscussionSection(
            bookId: book.id,
            bookTitle: book.title,
            userId: widget.userId!,
            displayName: widget.displayName!,
            service: widget.discussionService,
          ),
        ],
      ],
    ),
  );
}
