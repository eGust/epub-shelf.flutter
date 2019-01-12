import '../screen_base.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key, @required this.book}) : super(key: key);
  final Book book;
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) => Container();
}
