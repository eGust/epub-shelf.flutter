part of epub_shelf.components;

class Touchable extends StatelessWidget {
  Touchable({Key key, @required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(color: Colors.transparent),
        onTap: onPressed,
      );
}
