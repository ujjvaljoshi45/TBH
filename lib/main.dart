import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tobe_honest/screens/home_screen.dart';
import 'package:tobe_honest/screens/login/login_screen.dart';
import 'package:tobe_honest/screens/post/posts_screen.dart';
import 'package:tobe_honest/screens/profile_screen.dart';
import 'package:tobe_honest/screens/register/register_screen.dart';
import 'package:tobe_honest/screens/search_screen.dart';
import 'package:tobe_honest/screens/splash_screen.dart';

void main() async {
  if (Platform.isAndroid) {
    enterFullScreen();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

void initFirebase() async => await Firebase.initializeApp();

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
        PostsScreen.postsScreenId: (context) => PostsScreen(),
        ProfileScreen.profileScreenId: (context) => const ProfileScreen(),
        SearchScreen.searchScreenId: (context) => const SearchScreen(),
      },
    );
  }
}
