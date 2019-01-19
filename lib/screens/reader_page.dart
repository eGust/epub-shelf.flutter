import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

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
    return int.parse(r, onError: (_) => 0);
  }

  Future<void> _onWebEvent(List<dynamic> arguments) async {
    Map<String, dynamic> args = arguments[0];
    logd('[WebEvent] ${jsonEncode(args)}');
    if (args['type'] == 'CHAPTER_LOADED') {
      final Map<String, dynamic> chp = args['currentChapter'];
      _book.pageCount = chp['pageCount'];
      final page = (_book.progress * _book.pageCount).floor();
      _book.pageIndex = await _goPage(page);
    }
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

    final chapter = _book.currentChapter;
    final path = '/${chapter.content}';
    _loadedHistory = true;
    await _webViewController.injectScriptCode('openChapter("$path")');
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          BlankFrame(
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
          BlankFrame(
              child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Touchable(
                  onPressed: () {
                    logd('prev page');
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Touchable(
                  onPressed: _switchReadMode,
                ),
              ),
              Expanded(
                flex: 2,
                child: Touchable(
                  onPressed: () {
                    logd('next page');
                  },
                ),
              ),
            ],
          )),
          _isReading
              ? Container()
              : Frame(
                  body: Container(),
                ),
        ],
      );
}
