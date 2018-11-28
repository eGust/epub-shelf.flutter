part of epub_shelf.screens;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Frame(
        head: TopBar(
          title: Center(child: Text('Title', style: TextStyle(fontSize: 16.0))),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${device.width} x ${device.height}: isTablet = ${device.isTablet}',
              ),
              FlatButton(
                child: Text('test'),
                onPressed: () {},
              )
            ],
          ),
        ),
        foot: BottomBar(
          items: <Widget>[
            IconButton(
              iconSize: 28.0,
              icon: Icon(Icons.tab),
              onPressed: () {},
            ),
            IconButton(
              iconSize: 28.0,
              icon: Icon(Icons.satellite),
              onPressed: () {},
            ),
            IconButton(
              iconSize: 28.0,
              icon: Icon(Icons.verified_user),
              onPressed: () {},
            ),
          ],
        ),
      );
}
