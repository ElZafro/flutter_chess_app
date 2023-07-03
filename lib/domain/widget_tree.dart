import 'package:final_project/data/auth.dart';
import 'package:final_project/pages/login_register_page.dart';
import 'package:final_project/pages/home_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
