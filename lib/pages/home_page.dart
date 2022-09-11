import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // context.read<AuthRepository>().signOut();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(child: Text('HomePage')),
      ),
    );
  }
}
