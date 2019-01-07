import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:epub_package/epub_package.dart';

import '../api.dart';

const EPUB_FILES = [
  'A-Room-with-a-View-morrison.epub',
  'Beyond-Good-and-Evil-Galbraithcolor.epub',
  'epub31-v31-20170105.epub',
  'Metamorphosis-jackson.epub',
  'The-Prince-1397058899.epub',
  'The-Problems-of-Philosophy-LewisTheme.epub',
  'jy.epub', // 120M+
];

Future<File> extractFile(String fn) async {
  final file = File('${storage.documentPath}/books/$fn');
  if (await file.exists()) return file;

  final bytes = await rootBundle.load('assets/$fn');
  await file.create(recursive: true);
  return file.writeAsBytes(bytes.buffer.asUint8List());
}

Future<EpubPackage> testParseEpub(String fn) async {
  final file = await extractFile(fn);

  DateTime start = DateTime.now();
  final epub = EpubPackage(file);
  await epub.load();
  Duration ts = DateTime.now().difference(start);

  final fileSize = await file.length();
  logd('[time: $ts]\tloaded and parsed epub (${fileSize / 1000}KB): $fn');
  return epub;
}

Future<void> testAllWritePackage() async {
  for (var fn in EPUB_FILES) {
    final epub = await testParseEpub(fn);

    final jsonFile = File("${storage.documentPath}/shelf/$fn.json");
    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }

    jsonFile.writeAsString(jsonEncode(epub));
  }
}

Future<EpubPackage> testLoadJson(String fn) async {
  final jsonFile = File("${storage.documentPath}/shelf/$fn.json");

  if (!await jsonFile.exists()) return null;

  DateTime start = DateTime.now();
  final json = await jsonFile.readAsString();
  final pkg = await EpubPackage.loadFromJson(jsonDecode(json));
  Duration ts = DateTime.now().difference(start);

  final fileSize = await jsonFile.length();
  logd('[time: $ts]\tloaded Json (${fileSize / 1000}KB): $fn');
  return pkg;
}

Future<void> updateDb(EpubPackage pkg) async {
  final cnt = (await shelf.db
          .rawQuery('SELECT 1 FROM books WHERE id = ?', [pkg.filePath]))
      .length;
  if (cnt > 0) return;

  final ca = pkg.metadata.getCoverImageAsset();
  final bytes = ca == null ? null : await pkg.readAsBytes(ca.filename);
  final cover = bytes == null ? null : Uint8List.fromList(bytes);
  await shelf.db.insert('books', {
    'id': pkg.filePath,
    'cover': cover,
    'meta': jsonEncode(pkg.toJson()),
  });
}

Future<void> testEpubAll() async {
  await testAllWritePackage();
  for (var fn in EPUB_FILES) {
    final pkg = await testLoadJson(fn);
    await updateDb(pkg);
  }
}
