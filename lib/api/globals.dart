part of epub_shelf.api;

final logger = Logger();
final device = Device._();
final storage = Storage._();
final shelf = Shelf._();
final webService = WebService._();

Future<void> initializeGlobals() => Future.wait([
      Device.initialize(),
      Storage.initialize(),
      Shelf.initialize(),
      WebService.initialize(),
    ]);

Future<void> onAppPaused() async {
  logd('onAppPaused');
}

Future<void> onAppResumed() async {
  logd('onAppResumed');
}
