import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/sharedprefrance/sharedprefrace.dart';
import '../../../core/utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                },
                child: Text("logout")),
          ),
          Center(
            child: TextButton(
                onPressed: () async {
                  await SharedPrefsHelper.clearPreferences();
                  Navigator.pushReplacementNamed(context, Routes.onBoardingScreen);
                },
                child: Text("Clear onboarding ")),
          )
        ],
      ),
    );
  }
}
