import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String profileScreenId = 'profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person),
            Text('Username'),
          ],
        ),
      ),
    );
  }
}
