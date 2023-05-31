import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  static String profileScreenId = 'profile_screen';
  ProfileScreen({Key? key}) : super(key: key);
  User? user = FirebaseAuth.instance.currentUser;
  // String userName = user != null ? user!.displayName.toString() : 'User';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          textAlign: TextAlign.start,
          'ToBeHonest',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 20,
        shadowColor: Colors.blueGrey[500],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(
                    context, ModalRoute.withName(HomeScreen.homeScreenId));
              },
              icon: const Icon(
                Icons.logout,
                size: 30.0,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                size: 100.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${FirebaseAuth.instance.currentUser!.email}',
                style: const TextStyle(
                    fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
