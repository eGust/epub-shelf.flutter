part of epub_shelf.models;

class BookRouter {
  BookRouter(this.book);

  final EpubPackage book;

  Future<RouteResult> dispatch({String path}) async {
    final doc = book.getDocumentByPath(path.substring(1));
    return doc == null
        ? null
        : RouteResult(
            contentType: await doc.mimeType(),
            data: await doc.rawAsBytes(),
            encoding: doc.isCompressed ? 'deflate' : null,
          );
  }
}
