part of epub_shelf.api;

final logger = Logger();
final Device device = Device._();
final Storage storage = Storage._();
final Shelf shelf = Shelf._();

Future<void> initializeGlobals() => Future.wait([
      Device.initialize(),
      Storage.initialize(),
      Shelf.initialize(),
    ]);

Future<void> onAppPaused() async {
  logd('onAppPaused');
}

Future<void> onAppResumed() async {
  logd('onAppResumed');
}
