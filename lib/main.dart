import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/screens/walkthrough.dart';
import 'package:chatapp/services/dbdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  }catch (e) {
    print(e);
  }
  await Firebase.initializeApp();
  await getUser();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHATAPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser!=null ? SocialDashboard() : SocialWalkThrough(),
    );
  }
}

