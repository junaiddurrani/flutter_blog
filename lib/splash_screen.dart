import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
