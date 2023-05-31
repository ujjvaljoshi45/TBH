import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/constants.dart';
import 'package:tobe_honest/screens/posts_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static String loginScreenId = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool isLoggedIn = true;
  String message = '';

  Future<void> authenticateUser() async {
    await Firebase.initializeApp();
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = firebaseAuth.currentUser!;
      if (!user.emailVerified) {
        await firebaseAuth.signOut();
        setState(() {
          message = 'Verify Your Email to Login';
        });
      } else {
        setState(() {
          isLoggedIn = true;
        });
      }
    } catch (e) {
      message = 'Please Enter Correct Credentials!';
    }
  }

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                message,
                style: const TextStyle(
                    backgroundColor: Colors.red,
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              //TODO: Animate Text
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                  onChanged: (newEmail) => email = newEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: kInputDecoration.copyWith(hintText: 'Email')),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: TextField(
                onChanged: (newPassword) => password = newPassword,
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                decoration: kInputDecoration.copyWith(hintText: 'Password'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10,
              ),
              onPressed: () {
                authenticateUser();
                if (isLoggedIn) {
                  Navigator.pushNamed(context, PostsScreen.postsScreenId);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
