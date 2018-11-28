part of epub_shelf.components;

class BottomBar extends StatelessWidget {
  BottomBar({
    Key key,
    @required this.items,
    this.height = 54.0,
  }) : super(key: key);

  final List<Widget> items;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.from(items.map((widget) => Expanded(
                flex: 1,
                child: widget,
              ))),
        ),
      );
}
