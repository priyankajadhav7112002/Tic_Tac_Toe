import 'package:flutter/material.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/game_methods.dart';
// import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be visible
    gravity: ToastGravity.BOTTOM, // Position of the toast message on the screen
    backgroundColor: Colors.black.withOpacity(0.7), // Background color of the toast message
    textColor: Colors.white, // Text color of the toast message
    fontSize: 16.0, // Font size of the toast message
  );
}


class SocketMethods {
  // final _socketClient = SocketClient.instance.socket!;

  // late IO.Socket socket = IO.io('http://192.168.122.239:3000',
  late IO.Socket socket = IO.io('wws://thankful-relic-party.glitch.me',
      IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

  Socket get socketClient => socket;


  connectSocket() {
    socket.connect();
    socket.onConnect((data) => showToast("Connection Established ..."));
    socket.onConnectError(((data) => showToast("Connect error : $data")));
    socket.onDisconnect((data) => showToast("Connection got disconnected"));
  }

  // EMITS
  // void createRoom(String nickname) {
  //   if (nickname.isNotEmpty) {
  //     // socket.emit('createRoom', {
  //     //   'nickname': nickname,
  //     // });
  //     print("Connecting to room...");
  //     connectSocket();
  //     socket.emit('createRoom', {
  //       'nickname': nickname,
  //     });
  //   }
  // }

  // void createRoomSuccessListener(BuildContext context) {
  //   // socket.on('createRoomSuccess', (room) {
  //   //   print("Room Created Successfully : $room ");
  //   //   Navigator.pushNamed(context, GameScreen.routeName);
  //   // });
  //   socket.on('createRoomSuccess', (room) {
  //     print("Room Created Successfully : $room ");
  //     Navigator.pushNamed(context, GameScreen.routeName);
  //   });
  // }

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      connectSocket();
      socket.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      connectSocket();
      socket.emit('joinRoom', {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      socket.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  // LISTENERS
  void createRoomSuccessListener(BuildContext context) {
    socket.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    socket.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    socket.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    socket.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void updateRoomListener(BuildContext context) {
    socket.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context) {
    socket.on('tapped', (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      roomDataProvider.updateDisplayElements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      // check winnner
      GameMethods().checkWinner(context, socket);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    socket.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    socket.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}
