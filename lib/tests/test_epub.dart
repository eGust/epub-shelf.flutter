import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:epub_package/epub_package.dart';
// import 'package:shared_preferences/shared_preferences.dart';

const _EPUB_TEMP_DIR = 'epub';
const EPUB_FILES = [
  'A-Room-with-a-View-morrison.epub',
  'Beyond-Good-and-Evil-Galbraithcolor.epub',
  'epub31-v31-20170105.epub',
  'Metamorphosis-jackson.epub',
  'The-Prince-1397058899.epub',
  'The-Problems-of-Philosophy-LewisTheme.epub',
];

class TestEpub {
  static String _tempPath;
  static String get tempPath => _tempPath;
  static String get epubPath => '$tempPath/$_EPUB_TEMP_DIR';

  static Future<void> init() async {
    _tempPath = (await getTemporaryDirectory()).path;
    final epubDir = Directory(epubPath);
    print('epubDir: $epubPath');
    if (!(await epubDir.exists())) {
      await epubDir.create();
    }

    _exportEpubFiles();
  }

  static Future<void> testEpubSpeed() async {
    final packages =
        EPUB_FILES.map((fn) => EpubPackage(File('$epubPath/$fn'))).toList();

    final results = await Future.wait(packages.map((pkg) async {
      final start = DateTime.now();
      await pkg.load();
      final stop = DateTime.now();
      return {
        'start': start,
        'stop': stop,
        'package': pkg,
      };
    }));

    results.forEach((h) {
      final DateTime start = h['start'];
      final DateTime stop = h['stop'];
      final EpubPackage pkg = h['package'];
      final ts = stop.difference(start);
      print('[time: $ts]\t${pkg.properlyLoaded} - ${pkg.filepath}');
    });
  }

  static Future<File> extractAssetToFile(
      String assetName, String filename) async {
    final file = File(filename);
    if (await file.exists()) return file;

    final bytes = await rootBundle.load(assetName);
    await file.create(recursive: true);
    return file.writeAsBytes(bytes.buffer.asUint8List());
  }

  static Future<Iterable<File>> _exportEpubFiles() =>
      Future.wait(EPUB_FILES.map((fn) async {
        final bytes = await rootBundle.load('assets/$fn');
        final file = File('$epubPath/$fn');
        if (await file.exists()) return file;

        return file.writeAsBytes(bytes.buffer.asUint8List());
      }));

  Future<void> _testIosOnly() async {
    print('Test Large EPUB');
    print('--');

    final epub = await extractAssetToFile(
      'assets/jy.epub',
      "$epubPath/jy.epub",
    );

    final jsonFile = File("$tempPath/jy.epub.json");
    DateTime start;
    Duration ts;
    if (await jsonFile.exists()) {
      start = DateTime.now();
      final pkg = await EpubPackage.loadFromJson(
          jsonDecode(await jsonFile.readAsString()));
      ts = DateTime.now().difference(start);
      print('[time: $ts]\tloaded Json: ${pkg != null}');
    }

    final pkg = EpubPackage(epub);
    start = DateTime.now();
    await pkg.load();
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tloading ${pkg.filepath}');

    start = DateTime.now();
    final json = jsonEncode(pkg);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tencodeJson: ${json.length}');

    start = DateTime.now();
    if (!(await jsonFile.exists())) await jsonFile.create();
    await jsonFile.writeAsString(json);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tsaved Json: ${await jsonFile.exists()}');
  }
}
