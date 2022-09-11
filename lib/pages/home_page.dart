import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/pages/profile_page.dart';
import 'package:flutterfire_trial0/providers/auth/auth_provider.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthProvider>().signout();
              },
              icon: Icon(Icons.exit_to_app),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ));
              },
              icon: Icon(Icons.account_circle),
            )
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/flutter_favorite.png',
                  width: 100,
                ),
                const SizedBox(width: 20.0),
                Text(
                  'Provider',
                  style: TextStyle(fontSize: 42.0),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              'Provider is an awesome\nstate management library\nfor flutter!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            )
          ],
        )),
      ),
    );
  }
}
