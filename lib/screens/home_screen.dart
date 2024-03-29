import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/login/login_screen.dart';
import 'package:tobe_honest/screens/post/posts_screen.dart';
import 'package:tobe_honest/screens/register/register_screen.dart';

// Home Screen of the App (Second Screen)
class HomeScreen extends StatefulWidget {
  static String homeScreenId = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    // Get the current user if any
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future(() {
        // If User is found then navigate to PostsScreen with user as argument
        Navigator.pushNamed(context, PostsScreen.postsScreenId,
            arguments: user);
      });
    }
    // Else it will run the build method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Animate Text
              const Text(
                'ToBeHonest',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.loginScreenId);
                  },
                  child: const Text('Login')),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, RegisterScreen.registerScreenId);
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
