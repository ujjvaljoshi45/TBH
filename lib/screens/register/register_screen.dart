import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tobe_honest/screens/login/login_screen.dart';
import '../../constants.dart';

// Firebase Auth Instance
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// Register Screen of the App
class RegisterScreen extends StatefulWidget {
  static String registerScreenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = false; // Show Password
  late String email = ''; // Email
  late String password = ''; // Password
  late String reEnterPassword = ''; // Re-Enter Password
  late String firstName = ''; // First Name
  late String lastName = ''; // Last Name
  bool showSpinner = false; // Show Spinner
  bool loggedIn = false; // Logged In
  String message = ''; // Error Message

  // Save New User
  Future<User?> saveNewUser() async {
    await Firebase.initializeApp();

    // Check if all fields are filled
    if (password == reEnterPassword) {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        var user = firebaseAuth.currentUser;
        await user!.updateDisplayName('$firstName $lastName');
        await user!.updatePhotoURL(
            "https://firebasestorage.googleapis.com/v0/b/tobehonest-be7ed.appspot.com/o/files%2Fuser.png?alt=media&token=c0da5735-3120-4a9b-8c2f-b511b8c9887e");
        // try {
        //   const destination = 'files/user.png';
        //   final ref = FirebaseStorage.instance.ref(destination).child('file/');
        //   final photoURL = await ref.getDownloadURL();
        //   print(photoURL);
        //
        //   debugPrint(photoURL);
        // } catch (e) {
        //   debugPrint('dint work');
        // }

        // Get User and Add to Firestore Database
        user.reload();
        var updatedUser = firebaseAuth.currentUser;

        if (!updatedUser!.emailVerified) {
          await user.sendEmailVerification();
        }
        await FirebaseFirestore.instance.collection('myusers').add({
          'uid': updatedUser.uid,
          'displayName': updatedUser.displayName,
          'email': updatedUser.email,
          'photoURL':
              "https://firebasestorage.googleapis.com/v0/b/tobehonest-be7ed.appspot.com/o/files%2Fuser.png?alt=media&token=c0da5735-3120-4a9b-8c2f-b511b8c9887e",
        });

        setState(() {
          loggedIn = true;
          showSpinner = false;

          // Show Dialog Box 'Verification Link Send'
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
                              'Verification Link Send.',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                loggedIn = true;
                                Navigator.pushNamed(
                                    context, LoginScreen.loginScreenId);
                              },
                              child: const Text('Go to Login.'),
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
      } catch (e) {
        setState(() {
          showSpinner = false;
          // Show Dialog Box 'Please Fill All Fields'
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
                              'Please Fill All Fields.',
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
      }
    } else {
      setState(() {
        showSpinner = false;
        // Show Dialog Box 'Passwords don't match' (password is not equal to re-enter password)
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
                            'Passwords don\'t match',
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
    return null;
  }

  // Register App Bar
  AppBar registerAppBar() {
    return AppBar(
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
      appBar: registerAppBar(),
      body: Center(
        child: ModalProgressHUD(
          // Show Spinner
          inAsyncCall: showSpinner,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show Error Message
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
              ), //Email
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
                      setState(() {
                        showSpinner = false;
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
