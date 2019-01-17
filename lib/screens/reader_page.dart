import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import '../screen_base.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key key, @required this.book}) : super(key: key);
  final Book book;
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          BlankFrame(
            child: InAppWebView(
              initialUrl: 'http://127.0.0.1:9012/',
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
          BlankFrame(
            child: GestureDetector(
              child: Container(color: Colors.black12),
              onTap: () {
                logd('onPressed');
                if (_webViewController == null) return;

                _webViewController.injectScriptCode(
                    "const div = document.createElement('div'); div.innerText='test ${DateTime.now()}'; document.body.lastElementChild.after(div);");
              },
            ),
          ),
        ],
      );
}
