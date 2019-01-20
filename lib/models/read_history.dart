part of epub_shelf.models;

class ReadHistory {
  ReadHistory({this.package, this.id, this.cover});

  final String id;
  final Uint8List cover;
  final EpubPackage package;

  int get navCount => package.nav.count;

  Future<void> loadHistory() async {
    final r = await shelf.db.query(
      'books',
      columns: ['user_data'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (r.isNotEmpty) {
      final Map<String, dynamic> userData =
          jsonDecode(r.first['user_data'] ?? 'null');
      if (userData != null) {
        currentChapter = package.nav.findById(userData['chapter']);
        progress = userData['progress'];
        return;
      }
    }

    currentChapter = package.nav.first;
    progress = 0;
  }

  static const _Q_BOOKS =
      'SELECT id, cover, meta FROM books ORDER BY updated_at DESC';
  static Future<List<ReadHistory>> getBooks() async =>
      (await Future.wait((await shelf.db.rawQuery(_Q_BOOKS)).map((book) async {
        final Map<String, dynamic> jsonData = jsonDecode(book['meta']);
        jsonData['filename'] = '${storage.documentPath}${jsonData['filename']}';
        final package = await EpubPackage.loadFromJson(jsonData);
        if (package == null) return null;

        return ReadHistory(
          id: book['id'],
          cover: book['cover'],
          package: package,
        );
      })))
          .where((book) => book != null)
          .toList();

  NavPoint currentChapter;
  double progress;
  int pageCount;
  int pageIndex;
}
