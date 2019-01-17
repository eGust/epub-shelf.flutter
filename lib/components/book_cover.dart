part of epub_shelf.components;

class BookCover extends StatelessWidget {
  BookCover({
    Key key,
    @required this.book,
    @required this.onPressed,
  }) : super(key: key) {
    if (_size == null) {
      logd('width = ${device.width}');
      _size = ((device.width - 20.0) / 3).floor() - 20.0;
    }
  }

  static double _size;
  final Book book;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: _size,
        height: _size + 50,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10, width: 1.0),
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: Column(
            children: <Widget>[
              book.cover == null
                  ? Container(
                      height: _size,
                    )
                  : Container(
                      height: _size,
                      alignment: Alignment.center,
                      child: Image.memory(book.cover),
                    ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(book.package.nav.title),
                ),
              ),
            ],
          ),
        ),
      );
}
