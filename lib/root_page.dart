import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/authentication_page.dart';
import 'package:flutter_blog/home_page.dart';

import 'splash_screen.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  LoggedIn,
  NotLoggedIn,
  NotDetermined
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.NotDetermined;

  Future _checkAuthStatus() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User user = _firebaseAuth.currentUser;
    if(user == null) {
      setState(() {
        _authStatus = AuthStatus.NotLoggedIn;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.LoggedIn;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case AuthStatus.NotLoggedIn:
        return AuthenticationPage();
      case AuthStatus.LoggedIn:
        return HomePage();
        default:
          return SplashScreen();
    }
  }
}
