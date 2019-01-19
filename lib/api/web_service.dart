part of epub_shelf.api;

class RouteResult {
  const RouteResult({
    @required this.contentType,
    @required this.data,
    this.encoding,
  });

  final String contentType;
  final String encoding;
  final List<int> data;
}

typedef Router = Future<RouteResult> Function({String path});

class WebService {
  WebService._();

  static HttpServer _server;
  HttpServer get server => _server;

  static const STATIC_RESOURCES = {
    '__j': {
      'type': 'javascript',
      'path': 'web/index.js',
    },
    '__c': {
      'type': 'css',
      'path': 'web/index.css',
    },
  };

  Router onRoute;

  Future<void> router(HttpRequest req) async {
    final res = req.response;
    if (req.method == 'GET') {
      final path = req.requestedUri.path;
      if (path == '/') {
        String contentType;
        String body;
        final asset = STATIC_RESOURCES[req.requestedUri.query];
        if (asset == null) {
          logd('[GET] 200 /index.html');
          contentType = 'text/html';
          body = _HTML_INDEX;
        } else {
          logd('[GET] 200 /index.${asset['type']}');
          contentType = 'text/${asset['type']}';
          body = await rootBundle.loadString(asset['path']);
        }
        res.headers.add('Content-Type', contentType);
        res.headers.add('Cache-Control', _cacheControl);
        res.write(body);
        res.close();
        return;
      }

      final r = onRoute == null ? null : await onRoute(path: path);
      if (r != null) {
        logd('[GET] 200 $path => ${r.contentType}');
        res.headers.add('Content-Type', r.contentType);
        // res.headers.add('Cache-Control', 'no-cache');
        if (r.encoding != null) {
          res.headers.add('Content-Encoding', r.encoding);
        }
        res.add(r.data);
        res.close();
        return;
      }
    }
    logd('${req.method} 404! ${req.requestedUri.path}');
    res.statusCode = 404;
    res.close();
  }

  static Future<void> initialize() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, 9012);
    _server.listen(webService.router);
    logd('started server');
  }

  final _cacheControl = Logger.isDebug ? 'no-cache' : 'max-age=60';

  static const _HTML_INDEX =
      '''<!DOCTYPE html><html><head><link href="?__c" rel="stylesheet"></head><body><main><div id="chapter"><div id="content"></div></div></main><style id="theme"></style><script type="text/javascript" src="?__j"></script></body></html>''';
}
