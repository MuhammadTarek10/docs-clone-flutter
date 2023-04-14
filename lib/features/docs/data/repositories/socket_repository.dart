import 'dart:developer';

import 'package:docs/core/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final Socket _socketClient = SocketClient.instance.socket!;

  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }

  void typing(Map<String, dynamic> data) {
    log("Typing: $data");
    _socketClient.emit('typing', data);
  }

  void changeLister(Function(Map<String, dynamic>) onChange) {
    log("Changing");
    _socketClient.on('changes', (data) => onChange(data));
  }

  void autoSave(Map<String, dynamic> data) {
    log("Auto Save: $data");
    _socketClient.emit('save', data);
  }
}
