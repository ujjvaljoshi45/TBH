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
  // Enter in to full screen mode for android
  if (Platform.isAndroid) {
    enterFullScreen();
  }
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Run the app
  runApp(const MyApp());
}

// Enter in to full screen mode for android
void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

// Initialize Firebase (not using this function)
void initFirebase() async => await Firebase.initializeApp();

// Entry point of the app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Created a MaterialApp widget
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      // Set the theme of the app (dark mode)
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
        ),
        // Theme for the card widget
        cardTheme: CardTheme(
          color: Colors.blueGrey[700],
        ),
        // Color scheme for the app
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
      ),

      // Routing of the app
      initialRoute: SplashScreen.splashScreenId, //Set Initial Route

      // Define all the routes of the app
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
