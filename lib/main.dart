import 'dart:io';
import 'dart:convert';

import 'store/globals.dart';
import 'package:flutter/material.dart';
import 'package:epub_package/epub_package.dart';
import 'package:permission/permission.dart';

void main() {
  Globals.init();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          accentColor: Colors.amberAccent,
        ),
        home: AppHome(title: 'EPUB Shelf'),
      );
}

class AppHome extends StatefulWidget {
  AppHome({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
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
            title: Center(
                child: Text(widget.title, style: TextStyle(fontSize: 12.0))),
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
                'You have pushed the button this many times:',
              ),
              FlatButton(
                child: Text('test'),
                onPressed: _testEpub,
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

  void _testEpub() async {
    await Globals.testEpubSpeed();
    await _testIosOnly();
  }

  Future<void> _testIosOnly() async {
    print('Test Large EPUB');
    print('--');

    final epub = await Globals.extractAssetToFile(
      'assets/jy.epub',
      "${Globals.epubPath}/jy.epub",
    );

    final jsonFile = File("${Globals.tempPath}/jy.epub.json");
    DateTime start;
    Duration ts;
    if (await jsonFile.exists()) {
      start = DateTime.now();
      final pkg = await EpubPackage.loadFromJson(
          jsonDecode(await jsonFile.readAsString()));
      ts = DateTime.now().difference(start);
      print('[time: $ts]\tloaded Json: ${pkg != null}');
    }

    final pkg = EpubPackage(epub);
    start = DateTime.now();
    await pkg.load();
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tloading ${pkg.filepath}');

    start = DateTime.now();
    final json = jsonEncode(pkg);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tencodeJson: ${json.length}');

    start = DateTime.now();
    if (!(await jsonFile.exists())) await jsonFile.create();
    await jsonFile.writeAsString(json);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tsaved Json: ${await jsonFile.exists()}');
  }

  void _testAndroidOnly() async {
    if (!Platform.isAndroid) return;
    final path = '/sdcard/Download/jy.epub';
    final epub = File(path);

    if (!(await epub.exists())) return;

    final res = await Permission.requestPermissions([PermissionName.Storage]);
    print('[EXISTS] $res');

    DateTime start;
    Duration ts;
    final jsonFile = File('/sdcard/Download/jy.epub.json');

    if (await jsonFile.exists()) {
      start = DateTime.now();
      final pkg = await EpubPackage.loadFromJson(
          jsonDecode(await jsonFile.readAsString()));
      ts = DateTime.now().difference(start);
      print('[time: $ts]\tloaded Json: ${pkg != null}');
    }

    final pkg = EpubPackage(epub);
    start = DateTime.now();
    await pkg.load();
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tloading ${pkg.filepath}');

    start = DateTime.now();
    final json = jsonEncode(pkg);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tencodeJson: ${json.length}');

    start = DateTime.now();
    if (!(await jsonFile.exists())) await jsonFile.create();
    await jsonFile.writeAsString(json);
    ts = DateTime.now().difference(start);
    print('[time: $ts]\tsaved Json: ${await jsonFile.exists()}');
  }
}
