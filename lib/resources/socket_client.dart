import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  late IO.Socket socket;

  static SocketClient instance = SocketClient._internal();

  factory SocketClient() {
    return instance;
  }

  SocketClient._internal() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
    // socket = IO.io('http://192.168.0.22:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // socket.onConnect((data) => print("connection Established ..."));
    // socket.onConnectError(((data) => print("connect error : $data")));
    // socket.onDisconnect( (data) => print("Connection got disconnected"));


    print('inside socket to connect ...');
    socket.connect();
  }

  connectSocket( ) {
    socket = IO.io('http://localhost:3000');
    socket.onConnect((data) => print("Connection Established ..."));
    socket.onConnectError(((data) => print("Connect error : $data")));
    socket.onDisconnect( (data) => print("Connection got disconnected"));
  }

  // static SocketClient get instance {
  //   _instance ??= SocketClient._internal();
  //   return _instance!;
  // }
}
// 'http://192.168.0.22:3000'