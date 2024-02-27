import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  late IO.Socket socket;

  static SocketClient instance = SocketClient._internal();

  factory SocketClient() {
    return instance;
  }

  SocketClient._internal() {
    socket = IO.io('http://192.168.0.22:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  // static SocketClient get instance {
  //   _instance ??= SocketClient._internal();
  //   return _instance!;
  // }
}
// 'http://192.168.0.22:3000'