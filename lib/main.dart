import 'api/globals.dart';
import 'package:flutter/material.dart';

void main() async {
  await initializeGlobals();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          accentColor: Colors.amberAccent,
        ),
        home: HomeScreen(),
      );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(32.0),
          child: AppBar(
            leading: IconButton(
              padding: const EdgeInsets.all(3.0),
              icon: Icon(Icons.cached),
              onPressed: () {},
              iconSize: 20.0,
            ),
            title:
                Center(child: Text('Title', style: TextStyle(fontSize: 12.0))),
            actions: <Widget>[
              IconButton(
                padding: const EdgeInsets.all(3.0),
                icon: Icon(Icons.backup),
                onPressed: () {},
                iconSize: 20.0,
              ),
              IconButton(
                padding: const EdgeInsets.all(3.0),
                icon: Icon(Icons.tab),
                onPressed: () {},
                iconSize: 20.0,
              ),
            ],
          ),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Container(height: 0.0),
            ),
          ],
          onTap: (_) {},
        ),
      );
}
