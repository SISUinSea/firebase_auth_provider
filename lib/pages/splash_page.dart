import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/pages/home_page.dart';
import 'package:flutterfire_trial0/pages/signin_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth/auth_provider.dart';
import '../providers/auth/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>().state;

    if (authState.authStatus == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, HomePage.routeName);
      });
    } else if (authState.authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, SigninPage.routeName);
      });
    }
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
