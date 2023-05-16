import 'package:bentz_stocks/screens/something.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tabs_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: user != null ? const Something() : const TabsScreen(),
    );
  }
}
