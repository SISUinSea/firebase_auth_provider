import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/models/custom_error.dart';

import 'package:flutterfire_trial0/providers/signin/signin_state.dart';
import 'package:flutterfire_trial0/repositories/auth_repository.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;

  final AuthRepository authRepository;
  SigninProvider({
    required this.authRepository,
  });

  Future<void> signin({required String email, required String password}) async {
    _state = _state.copyWith(signinStatus: SigninStatus.submitting);
    notifyListeners();

    try {
      await authRepository.signin(email: email, password: password);
      _state = _state.copyWith(signinStatus: SigninStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
