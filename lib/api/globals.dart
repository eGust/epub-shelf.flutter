import 'device.dart';
import 'storage.dart';

export 'device.dart' show device;
export 'storage.dart' show storage;

Future<void> initializeGlobals() => Future.wait([
      Device.initialize(),
      Storage.initialize(),
    ]);
