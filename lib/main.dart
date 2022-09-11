import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/pages/home_page.dart';
import 'package:flutterfire_trial0/pages/signin_page.dart';
import 'package:flutterfire_trial0/pages/signup_page.dart';
import 'package:flutterfire_trial0/pages/splash_page.dart';
import 'package:flutterfire_trial0/providers/auth/auth_provider.dart';
import 'package:flutterfire_trial0/providers/signin/signin_provider.dart';
import 'package:flutterfire_trial0/providers/signup/signup_provider.dart';
import 'package:flutterfire_trial0/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseAuth: fbAuth.FirebaseAuth.instance,
              firebaseFirestore: FirebaseFirestore.instance),
        ),
        StreamProvider<fbAuth.User?>(
          create: (context) => context.read<AuthRepository>().user,
          initialData: null,
        ),
        ChangeNotifierProxyProvider<fbAuth.User?, AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
          ),
          update: (BuildContext context, fbAuth.User? userStream,
                  AuthProvider? authProvider) =>
              authProvider!..update(userStream),
        ),
        ChangeNotifierProvider<SigninProvider>(
          create: (context) =>
              SigninProvider(authRepository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<SignupProvider>(
          create: (context) =>
              SignupProvider(authRepository: context.read<AuthRepository>()),
        )
      ],
      child: MaterialApp(
        title: 'Auth Provider',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: {
          SigninPage.routeName: (context) => SigninPage(),
          SignupPage.routeName: (context) => SignupPage(),
          HomePage.routeName: (context) => HomePage(),
        },
      ),
    );
  }
}
