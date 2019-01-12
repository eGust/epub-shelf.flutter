import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api.dart';
import 'screens/home_page.dart';

void main() async {
  await initializeGlobals();
  runApp(App(home: HomePage()));
}

class App extends StatefulWidget {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    accentColor: Colors.amberAccent,
  );

  App({Key key, @required this.home}) : super(key: key);

  final Widget home;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    device.style = SystemUiOverlayStyle.light;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        {
          onAppPaused();
          break;
        }
      case AppLifecycleState.resumed:
        {
          onAppResumed();
          break;
        }
      case AppLifecycleState.inactive:
        {
          logd('inactive');
          break;
        }
      case AppLifecycleState.suspending:
        {
          logd('suspending');
          break;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: App.themeData,
        home: Material(child: widget.home),
      );
}
