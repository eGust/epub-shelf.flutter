import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/device.dart';

class Storage {
  static String _tempPath;
  static String _documentPath;
  static SharedPreferences _sharedPreferences;

  Storage._();

  String get tempPath => _tempPath;
  String get documentPath => _documentPath;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  static Future<void> initialize() async {
    if (storage != null) return;

    storage = Storage._();
    _tempPath = (await getTemporaryDirectory()).path;
    _documentPath = (await getApplicationDocumentsDirectory()).path;
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}

Storage storage;
