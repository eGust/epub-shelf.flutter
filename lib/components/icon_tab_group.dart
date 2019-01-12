part of epub_shelf.components;

typedef SelectIndexCallback = void Function(int);

class IconTabGroup extends StatelessWidget {
  IconTabGroup({
    Key key,
    @required this.icons,
    @required this.activeIndex,
    @required this.onSelected,
  }) : super(key: key);

  final List<Icon> icons;
  final int activeIndex;
  final SelectIndexCallback onSelected;

  @override
  Widget build(BuildContext context) => BottomBar(
        items: icons
            .asMap()
            .entries
            .map((icon) => IconButton(
                  key: Key(icon.key.toString()),
                  icon: icon.value,
                  color:
                      icon.key == activeIndex ? Colors.white : Colors.white30,
                  iconSize: 28.0,
                  onPressed: () => onSelected(icon.key),
                ))
            .toList(),
      );
}
