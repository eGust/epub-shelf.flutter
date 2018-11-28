part of epub_shelf.api;

class Device {
  static double _statusBarHeight;
  static Size _size;
  static double _pixelRatio;

  Device._();

  static Future<void> initialize() async {
    final mediaData = device.queryMediaData();
    _size = mediaData.size;
    _statusBarHeight = mediaData.padding.top;
    _pixelRatio = mediaData.devicePixelRatio;
  }

  MediaQueryData queryMediaData() => MediaQueryData.fromWindow(window);

  double get statusBarHeight => _statusBarHeight;
  double get pixelRatio => _pixelRatio;
  Size get size => _size;

  double get width => _size.shortestSide;
  double get height => _size.longestSide;
  double get resolutionWidth => width * _pixelRatio;
  double get resolutionHeight => height * _pixelRatio;
  bool get isTablet => width > 600;

  static bool _hidden = false;
  static SystemUiOverlayStyle _style;

  bool get hidden => _hidden;
  set hidden(bool value) {
    if (value == _hidden) return;
    _hidden = value;
    SystemChrome.setEnabledSystemUIOverlays(
        value ? [] : SystemUiOverlay.values);
  }

  SystemUiOverlayStyle get style => _style;
  set style(SystemUiOverlayStyle value) {
    _style = value;
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  void hide() {
    hidden = true;
  }

  void show() {
    hidden = false;
  }
}
