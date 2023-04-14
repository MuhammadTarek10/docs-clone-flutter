import 'package:docs/config/apis.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  Socket? socket;
  static SocketClient? _shared;

  SocketClient._internal() {
    socket = io(
      Apis.base,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build(),
    );
    socket!.connect();
  }

  static SocketClient get instance {
    _shared ??= SocketClient._internal();
    return _shared!;
  }
}
