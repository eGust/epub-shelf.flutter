part of epub_shelf.components;

class Frame extends StatelessWidget {
  Frame({
    Key key,
    TopBar head,
    @required Widget body,
    Widget foot,
  })  : widgets = [
          head,
          Expanded(
            child: SingleChildScrollView(child: body),
            flex: 1,
          ),
          foot,
        ].where((w) => w != null).toList(),
        super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) => Material(
        child: Column(
          children: widgets,
        ),
      );
}
