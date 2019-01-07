part of epub_shelf.models;

class Book {
  Book({this.package, this.id, this.cover});
  final String id;
  final Image cover;
  final EpubPackage package;
}

class ReadHistory {
  static const _Q_BOOKS =
      'SELECT id, cover, meta FROM books ORDER BY updated_at DESC';
  static Future<List<Book>> getBooks() async {
    return (await Future.wait(
            (await shelf.db.rawQuery(_Q_BOOKS)).map((book) async {
      final package = await EpubPackage.loadFromJson(jsonDecode(book['meta']));
      if (package == null) return null;

      return Book(
        id: book['id'],
        cover: Image.memory(book['cover']),
        package: package,
      );
    })))
        .where((book) => book != null)
        .toList();
  }
}
