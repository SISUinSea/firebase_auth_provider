import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/providers/auth/auth_state.dart';
import '../../repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.unknown();
  AuthState get state => _state;

  final AuthRepository authRepository;
  AuthProvider({
    required this.authRepository,
  });

  void update(fbAuth.User? user) {
    if (user != null) {
      _state =
          _state.copyWith(authStatus: AuthStatus.authenticated, user: user);
    } else {
      _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print('authState updated: $state');
    notifyListeners();
  }

  void signout() async {
    await authRepository.signOut();
  }
}
