import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String code;
  final String plugin;
  final String message;
  CustomError({
    this.code = '',
    this.plugin = '',
    this.message = '',
  });

  @override
  List<Object> get props => [code, plugin, message];

  @override
  String toString() =>
      'CustomError(code: $code, plugin: $plugin, message: $message)';
}
