part of epub_shelf.components;

class TopBar extends StatelessWidget {
  TopBar({
    Key key,
    this.left = const [],
    @required this.title,
    this.right = const [],
    this.height = 40.0,
  }) : super(key: key);

  final List<Widget> left;
  final Widget title;
  final List<Widget> right;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height + device.statusBarHeight,
        padding: EdgeInsets.only(top: device.statusBarHeight),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: left,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              flex: 1,
            ),
            title,
            Expanded(
              child: Row(
                children: right,
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              flex: 1,
            ),
          ],
        ),
      );
}
