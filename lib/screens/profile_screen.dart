import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String profileScreenId = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userUid;
  late String userDisplayName = '';
  bool gotDisplayName = false;

  Future<void> getUser(String uid) async {
    await Firebase.initializeApp();
    var docRef = await FirebaseFirestore.instance.collection('myusers').get();
    for (var doc in docRef.docs) {
      if (doc.get('uid') == uid) {
        setState(() {
          userDisplayName = doc.get('displayName');
          gotDisplayName = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!gotDisplayName) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      userUid = args;
      getUser(userUid);
    }
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
                callNavigator();
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
                userDisplayName,
                style: const TextStyle(
                    fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callNavigator() =>
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.homeScreenId));
}
