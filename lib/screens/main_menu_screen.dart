import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Responsive/responsive.dart';
import 'package:tic_tac_toe/screens/create_room_screen.dart';
import 'package:tic_tac_toe/screens/join_room_screen.dart';

import '../widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({super.key});

  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
          child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        
        
        children: [
          CustomButton(
            onTap: () => createRoom(context),
            text: 'Create Room',
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onTap: () => joinRoom(context),
            text: 'Join Room',
          )
        ],
      ),
    )));
  }
}
