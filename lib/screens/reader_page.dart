import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:epub_package/epub_package.dart';

import '../screen_base.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key, @required this.book}) : super(key: key);
  final ReadHistory book;

  @override
  _ReaderPageState createState() => _ReaderPageState(book);
}

class _ReaderPageState extends State<ReaderPage> {
  _ReaderPageState(this._book);

  ReadHistory _book;

  InAppWebViewController _webViewController;
  bool _isReading = true;
  Router _oldRouter;

  @override
  void initState() {
    super.initState();
    _oldRouter = webService.onRoute;
    final router = BookRouter(_book.package);
    webService.onRoute = router.dispatch;
  }

  @override
  void dispose() {
    webService.onRoute = _oldRouter;
    super.dispose();
  }

  Future<int> _goPage(int page) async {
    final r = await _webViewController.injectScriptCode('goPage($page)');
    return int.tryParse(r) ?? 0;
  }

  Future<void> _onWebEvent(List<dynamic> arguments) async {
    Map<String, dynamic> args = arguments[0];
    logd('[WebEvent] ${jsonEncode(args)}');

    switch (args['type']) {
      case 'CHAPTER_LOADED':
        {
          final Map<String, dynamic> chp = args['currentChapter'];
          _book.pageCount = chp['pageCount'];
          final page = (_book.progress * _book.pageCount).floor();
          _book.pageIndex = await _goPage(page < 0 ? -1 : page);
          logd('page: ${_book.pageIndex} / ${_book.pageCount})');
          break;
        }
      case 'PRESSED':
        {
          final pos = args['x'] / device.width;
          if (pos < 0.3) {
            _swipePage(_PREV_PAGE);
          } else if (pos > 0.7) {
            _swipePage(_NEXT_PAGE);
          } else {
            _switchReadMode();
          }
        }
    }
  }

  static const _PREV_PAGE = -1;
  static const _NEXT_PAGE = 1;

  Future<void> _swipePage(int direction) async {
    final page = _book.pageIndex + direction;
    if (page >= 0 && page < _book.pageCount) {
      _book.pageIndex = await _goPage(page);
      return;
    }

    final cur = _book.currentChapter;
    _openChapter(direction < 0 ? cur.prev : cur.next, direction: direction);
  }

  Future<void> _openChapter(NavPoint chapter, {int direction}) async {
    if (chapter == null) {
      loge('NO MORE CHAPTER!');
      return;
    }

    if (direction != null) {
      _book.progress = direction < 0 ? -1 : 0;
    }
    final path = '/${chapter.content}';
    logd('open chapter: $path (${chapter.index} / ${_book.navCount})');
    await _webViewController.injectScriptCode('openChapter("$path")');
    _book.currentChapter = chapter;
  }

  void _switchReadMode() {
    setState(() {
      _isReading = !_isReading;
    });
  }

  bool _loadedHistory = false;

  Future<void> _openHistory() async {
    if (_loadedHistory) return;

    await Future.wait([
      _book.loadHistory(),
      (() async {
        while (true) {
          final ping = await _webViewController.injectScriptCode('ping()');
          if (ping == 'ping') break;
        }
      })(),
    ]);
    if (!mounted) return;

    _loadedHistory = true;
    _openChapter(_book.currentChapter);
  }

  @override
  Widget build(BuildContext context) => Stack(children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(top: device.statusBarHeight + 10, bottom: 20.0),
          color: Colors.white,
          child: InAppWebView(
            initialUrl: 'http://127.0.0.1:9012/',
            initialOptions: {'clearCache': true},
            onWebViewCreated: (controller) {
              logd('[onWebViewCreated]');
              _webViewController = controller;
              _webViewController.addJavaScriptHandler('EPUB', _onWebEvent);
            },
            onLoadStop: (_, url) {
              logd('onLoadStop: $url');
              _openHistory();
            },
          ),
        ),
        _isReading
            ? Container()
            : TransparentFrame(
                head: TopBar(
                  title: Center(
                      child: Text('Title', style: TextStyle(fontSize: 16.0))),
                ),
                body: Touchable(
                  onPressed: _switchReadMode,
                ),
                foot: IconTabGroup(
                  activeIndex: 0,
                  icons: [
                    const Icon(Icons.library_books),
                    const Icon(Icons.history),
                    const Icon(Icons.settings),
                  ],
                  onSelected: (_) => {},
                ),
              ),
      ]);
}
