part of epub_shelf.api;

final logger = Logger();
final Device device = Device._();
final Storage storage = Storage._();

Future<void> initializeGlobals() => Future.wait([
      Device.initialize(),
      Storage.initialize(),
    ]);

Future<void> onAppPaused() async {
  logd('onAppPaused');
}

Future<void> onAppResumed() async {
  logd('onAppResumed');
}
