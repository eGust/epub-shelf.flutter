import '../screen_base.dart';
import 'home/book_shelf.dart';
import 'reader_page.dart';

import '../tests/test_epub.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeTabIndex = 0;

  Future<void> _showReader(ReadHistory book) async {
    await Navigator.push(
      context,
      buildRoute(ReaderPage(book: book)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Frame(
        head: TopBar(
          title: Center(child: Text('Title', style: TextStyle(fontSize: 16.0))),
        ),
        body: SingleChildScrollView(
          child: activeTabIndex == 0
              ? BookShelf(
                  onSelectedBook: (book) => _showReader(book),
                )
              : Center(
                  child: Text(""),
                ),
        ),
        foot: IconTabGroup(
          activeIndex: activeTabIndex,
          icons: [
            const Icon(Icons.library_books),
            const Icon(Icons.history),
            const Icon(Icons.settings),
          ],
          onSelected: (tabIndex) => setState(() {
                activeTabIndex = tabIndex;
                if (tabIndex == 1) {
                } else if (tabIndex == 2) {
                  testEpubAll();
                }
              }),
        ),
      );
}
