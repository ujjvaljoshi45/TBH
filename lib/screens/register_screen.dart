import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tobe_honest/screens/login_screen.dart';
import '../constants.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  static String registerScreenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = false;
  late String email;
  late String password;
  late String reEnterPassword;
  late String firstName;
  late String lastName;
  bool showSpinner = false;
  bool loggedIn = false;
  String message = '';
  Future<User?> saveNewUser() async {
    await Firebase.initializeApp();

    if (password == reEnterPassword) {
      print('now registering');
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        var user = firebaseAuth.currentUser;
        await user!.updateDisplayName('$firstName $lastName');
        user.reload();
        var updatedUser = firebaseAuth.currentUser;

        if (!updatedUser!.emailVerified) {
          await user.sendEmailVerification();
        }
        await FirebaseFirestore.instance.collection('myusers').add({
          'uid': updatedUser.uid,
          'displayName': updatedUser.displayName,
          'email': updatedUser.email,
          'isVerified': updatedUser.emailVerified
        });
        loggedIn = true;
      } catch (e) {
        setState(() {
          message = 'Error In Registering';
        });
      }
    } else {
      print('$email\n$password\n$reEnterPassword\n$firstName\n$lastName');
    }
    return null;
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
                // TODO: Animate Text
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 10.0, bottom: 15.0),
                      child: TextField(
                        onChanged: (newFirstName) => firstName = newFirstName,
                        style: const TextStyle(color: Colors.black),
                        decoration: kInputDecoration.copyWith(
                          hintText: 'First Name',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 40.0, bottom: 15.0),
                      child: TextField(
                        onChanged: (newLastName) => lastName = newLastName,
                        style: const TextStyle(color: Colors.black),
                        decoration:
                            kInputDecoration.copyWith(hintText: 'Last Name'),
                      ),
                    ),
                  )
                ],
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
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  onChanged: (newReEnterPassword) =>
                      reEnterPassword = newReEnterPassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.black),
                  obscureText: !showPassword,
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Re-Enter Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: showPassword
                              ? const Icon(Icons.remove_red_eye_sharp)
                              : const Icon(Icons.remove_red_eye_outlined))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
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
                    var user = await saveNewUser();
                    if (loggedIn) {
                      Navigator.pushNamed(context, LoginScreen.loginScreenId);
                    } else {
                      setState(() {
                        message = 'Please Retry Registering';
                      });
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
