import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/home_screen.dart';
import 'package:tobe_honest/screens/login_screen.dart';
import 'package:tobe_honest/screens/posts_screen.dart';
import 'package:tobe_honest/screens/profile_screen.dart';
import 'package:tobe_honest/screens/register_screen.dart';
import 'package:tobe_honest/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
      ),
      initialRoute: SplashScreen.splashScreenId,
      routes: {
        SplashScreen.splashScreenId: (context) => const SplashScreen(),
        HomeScreen.homeScreenId: (context) => const HomeScreen(),
        LoginScreen.loginScreenId: (context) => const LoginScreen(),
        RegisterScreen.registerScreenId: (context) => const RegisterScreen(),
        PostsScreen.postsScreenId: (context) => const PostsScreen(),
        ProfileScreen.profileScreenId: (context) => const ProfileScreen(),
      },
    );
  }
}
