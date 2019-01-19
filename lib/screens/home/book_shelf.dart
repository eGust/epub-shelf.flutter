import '../../screen_base.dart';

class BookShelf extends StatefulWidget {
  BookShelf({Key key, @required this.onSelectedBook}) : super(key: key);
  final SelectBookCallback onSelectedBook;

  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  final books = <ReadHistory>[];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final history = await ReadHistory.getBooks();
    if (!mounted) return;

    setState(() {
      books.addAll(history);
    });
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 2.0,
        runSpacing: 8.0,
        children: books
            .map((book) => BookCover(
                  key: Key(book.id),
                  book: book,
                  onPressed: () => widget.onSelectedBook(book),
                ))
            .toList(),
      ));
}
