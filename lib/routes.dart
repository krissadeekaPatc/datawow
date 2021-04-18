import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/create_post/create_post_page.dart';
import 'package:todo/screens/login/login_forms.dart';
import 'package:todo/screens/login/register.dart';
import 'package:todo/screens/profiles_setup/profiles.dart';
import 'package:todo/screens/writenewtodo.dart';

import 'screens/home.dart';
import 'screens/login/login.dart';

enum ROUTE_NAME {
  home,
  register,
  login,
  profiles,
  controller,
  manual,
  newlist,
  login_forms,
  sign_up,
  create_post,
}

class AppRoutes extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String initPage() {
    try {
      if (_auth.currentUser.uid != null) {
        return "/home";
      }
      return "/login";
    } catch (e) {
      return "/login";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initPage(),
      routes: {
        '/login': (c) => LoginPage(),
        '/login_forms': (c) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/newlist': (context) => WriteNewList(),
        '/sign_up': (c) => SignUpScreen(),
        '/profiles': (c) => ProfilesSetting(),
        '/create_post': (c) => PublicPostPage(),
      },
      theme: ThemeData(
        backgroundColor: Colors.white,
        cardColor: Colors.transparent,
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        brightness: Brightness.light,
      ),
    );
  }
}
