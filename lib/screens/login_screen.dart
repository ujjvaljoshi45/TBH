import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  bool isLoggedIn = false;
  String message = '';
  bool showSpinner = false;

  Future<User?> authenticateUser() async {
    await Firebase.initializeApp();
    User? user;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = firebaseAuth.currentUser;
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
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
      setState(() {
        message = 'Please Enter Correct Credentials Or Check Your Network';
      });
      return null;
    }
    return user;
  }

  Future<void> runForgetPassword() async {
    if (email.isNotEmpty) {
      await Firebase.initializeApp();
      await firebaseAuth.sendPasswordResetEmail(email: email);
      setState(() {
        message = 'Check Spam Inbox';
      });
    } else {
      setState(() {
        message = 'Enter Email!';
      });
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
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: TextField(
                  onChanged: (newPassword) => password = newPassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: kInputDecoration.copyWith(hintText: 'Password'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    runForgetPassword();
                  },
                  child: const Text('Forgot Password?')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 10,
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (email != '' && password != '') {
                    var user = await authenticateUser();
                    if (isLoggedIn) {
                      callNavigator(user);
                    } else {
                      setState(() {
                        message = 'Please Retry.';
                      });
                    }
                  } else {
                    if (email == '') {
                      setState(() {
                        message = 'Enter Email.';
                      });
                    } else {
                      message = 'Enter Password.';
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callNavigator(user) {
    Navigator.pushNamed(context, PostsScreen.postsScreenId, arguments: user);
  }
}
