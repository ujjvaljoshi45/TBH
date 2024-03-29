import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tobe_honest/constants.dart';
import 'package:tobe_honest/screens/post/posts_screen.dart';

// Firebase Authentication instance
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// Login Screen of the App (Third Screen)
class LoginScreen extends StatefulWidget {
  static String loginScreenId = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email = ''; // The email that user will enter in the text field
  late String password =
      ''; // The password that user will enter in the text field
  bool isLoggedIn = false; // To check if user is logged in or not
  String message = ''; // To show error message
  bool showSpinner = false; // To show spinner while user is logging in

  // Authenticate the user
  Future<User?> authenticateUser() async {
    email.trim();
    password.trim();

    await Firebase.initializeApp();

    User? user;

    // Check if email and password is empty
    if (email.isEmpty || password.isEmpty) {
      // Show error message Dialog box
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Please Enter Email and Password',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
      return null;
    }

    // Try to login the user
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = firebaseAuth.currentUser;
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
        await firebaseAuth.signOut();
        setState(() {
          showSpinner = false;
          showDialog(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shadowColor: Colors.white,
                      child: Container(
                        height: 100.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Please Verify Your Email.',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Go Back'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
        return null;
      } else {
        setState(() {
          showSpinner = false;
          isLoggedIn = true;
        });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Error, Please Enter Correct Credentials.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
      return null;
    }
    return user;
  }

  // Forget Password
  Future<void> runForgetPassword() async {
    if (email.isNotEmpty) {
      await Firebase.initializeApp();
      await firebaseAuth.sendPasswordResetEmail(email: email);
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Email Sent, Please Check Spam Inbox.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
    } else {
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Please Enter Email',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
    }
  }

  // Resend Verification Link
  Future<void> resendVerificationLink() async {
    if (email.isNotEmpty) {
      await Firebase.initializeApp();
      var mAuth = FirebaseAuth.instance;
      User? user = mAuth.currentUser;
      await user?.sendEmailVerification();
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Email Sent, Please Check Spam Inbox.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
    } else {
      setState(() {
        showSpinner = false;
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Please Enter Email',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      });
    }
  }

  // Call the PostsScreen
  void callNavigator(user) {
    Navigator.pushNamed(context, PostsScreen.postsScreenId, arguments: user);
  }

  // AppBar of the Login Screen
  AppBar loginAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey[700],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(),
      body: Center(
        child: ModalProgressHUD(
          // Show spinner while some async task is running
          inAsyncCall: showSpinner,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: message != '',
                child: Padding(
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
              TextButton(
                  onPressed: () {
                    resendVerificationLink();
                  },
                  child: const Text('Resend Verification Link.')),
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

                  // Run Method to Authenticate the user
                  var user = await authenticateUser();
                  // if user is not null then call the PostsScreen
                  if (isLoggedIn) {
                    callNavigator(user);
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
}
