import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'root_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blog',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        primaryColorDark: Colors.yellow,
        accentColor: Colors.yellow
      ),
      home: RootPage(),
    );
  }
}