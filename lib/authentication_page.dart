import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _btnTitle = 'Sign In';
  bool _isSignIn = true;
  String _authTitle = 'Create Account';
  bool _isLoading = false;

  Future _performAuthentication(BuildContext context, String email, String password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();
    if(_isSignIn) {
      setState(() {
        _isLoading = true;
      });
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
        if(value != null) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      await  _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        if(value != null) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  _changeButtonTitle() {
    if(_btnTitle == 'Sign In') {
      setState(() {
        _btnTitle = 'Create Account';
        _authTitle = 'Sign In';
        _isSignIn = false;
      });
    } else {
      setState(() {
        _btnTitle = 'Sign In';
        _authTitle = 'Create Account';
        _isSignIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.web_outlined,
                        color: Colors.yellow,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Center(child: Text('Flutter Blog App', style: TextStyle(color: Colors.yellow, fontSize: 25.0), textAlign: TextAlign.center)),
                    ],
                  ),
                  SizedBox(height: 80.0),
                  Container(
                    height: 50.0,
                    child: TextFormField(
                      style: TextStyle(color: Colors.yellow),
                      controller: _emailController,
                      cursorColor: Colors.yellow,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.yellow[100],
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.yellow[100],
                          ),
                        ),
                        labelText: 'Type Email',
                        labelStyle: TextStyle(color: Colors.yellow[100], fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 50.0,
                    child: TextFormField(
                      style: TextStyle(color: Colors.yellow),
                      controller: _passwordController,
                      cursorColor: Colors.yellow,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.yellow[100],
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.yellow[100],
                          ),
                        ),
                        labelText: 'Type Password',
                        labelStyle: TextStyle(color: Colors.yellow[100], fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if(_emailController.text.isEmpty && _passwordController.text.isEmpty) {
                          debugPrint('Provide username or password');
                        } else {
                          _performAuthentication(context, _emailController.text, _passwordController.text);
                        }
                      },
                      color: Colors.yellow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      child: Text(_btnTitle, style: GoogleFonts.roboto(color: Colors.black87, fontSize: 20.0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FlatButton(
                      onPressed: _changeButtonTitle,
                      child: Text(_authTitle, style: GoogleFonts.roboto(color: Colors.yellow, fontSize: 16.0))
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading ? Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: LinearProgressIndicator(minHeight: 5.0),
              ),
            ) : Container(width: 0.0, height: 0.0)
          ],
        ),
      ),
    );
  }
}
