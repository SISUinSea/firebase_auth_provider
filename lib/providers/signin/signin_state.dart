import 'package:equatable/equatable.dart';

import 'package:flutterfire_trial0/models/custom_error.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState extends Equatable {
  final SigninStatus signinStatus;
  final CustomError error;
  SigninState({
    required this.signinStatus,
    required this.error,
  });

  factory SigninState.initial() =>
      SigninState(signinStatus: SigninStatus.initial, error: CustomError());

  @override
  List<Object> get props => [signinStatus, error];

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, error: $error)';

  SigninState copyWith({
    SigninStatus? signinStatus,
    CustomError? error,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      error: error ?? this.error,
    );
  }
}
