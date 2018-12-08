part of epub_shelf.api;

class Storage {
  static String _tempPath;
  static String _documentPath;
  static SharedPreferences _sharedPreferences;

  Storage._();

  String get tempPath => _tempPath;
  String get documentPath => _documentPath;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  static Future<void> initialize() async {
    _tempPath = (await getTemporaryDirectory()).path;
    _documentPath = (await getApplicationDocumentsDirectory()).path;
    _sharedPreferences = await SharedPreferences.getInstance();
    logd("temp: $_tempPath");
    logd("doc: $_documentPath");
  }
}
