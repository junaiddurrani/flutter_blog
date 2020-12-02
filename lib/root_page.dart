import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {LoggedIn, NotLoggedIn}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.NotLoggedIn;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkAuthStatus() async {
    User currentUser = _auth.currentUser;
    if(currentUser == null) {
      setState(() {
        _authStatus = AuthStatus.NotLoggedIn;
        _registerUser();
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.LoggedIn;
      });
    }
  }

  Future<void> _registerUser() {
    _auth.signInAnonymously().then((value) {
      if(value != null) {
        setState(() {
          _authStatus = AuthStatus.LoggedIn;
        });
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    switch(_authStatus) {
      case AuthStatus.LoggedIn:
      return HomePage();
      break;
      case AuthStatus.NotLoggedIn:
        return _splashScreen();
        break;
      default:
        return _splashScreen();
    }
  }

  Widget _splashScreen() {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(width: 50.0, height: 50.0, child: CircularProgressIndicator()),
      ),
    );
  }

}
