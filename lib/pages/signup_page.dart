import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutterfire_trial0/models/custom_error.dart';
import 'package:flutterfire_trial0/pages/signup_page.dart';
// import 'package:flutterfire_trial0/providers/auth/auth_provider.dart';
import 'package:flutterfire_trial0/providers/signup/signup_provider.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../providers/signup/signup_state.dart';
import '../utils/error_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _name, _email, _password;
  TextEditingController _passwordController = TextEditingController();

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    print(
        "Sign-in method at _submit method at Sign-in Page is Successfully loaded! email: $_email, password: $_password");
    try {
      await context
          .read<SignupProvider>()
          .signup(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = context.watch<SignupProvider>().state;
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  Image.asset('assets/images/flutter_logo.png'),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'name',
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your name.';
                      } else if (value.length < 2) {
                        return 'Name must be at least 2 characters.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) => _name = value,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your email.';
                      } else if (!isEmail(value.trim())) {
                        return 'Enter a vaild email.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) => _email = value,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'password',
                        prefixIcon: Icon(Icons.lock)),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter password';
                      } else if (value.length < 6) {
                        return 'Password should be at least 6 characters';
                      } else
                        return null;
                    },
                    onSaved: (String? value) => _password = value,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'confirm password',
                        prefixIcon: Icon(Icons.lock)),
                    validator: (String? value) {
                      if (_passwordController.text != value) {
                        return 'Please enter same password.';
                      } else
                        return null;
                    },
                    onSaved: (String? value) => _password = value,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                        signupState.signupStatus == SignupStatus.submitting
                            ? 'Loading...'
                            : 'Sign up'),
                    onPressed:
                        signupState.signupStatus == SignupStatus.submitting
                            ? null
                            : _submit,
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    child: Text('Sign in now!'),
                    onPressed: () {
                      signupState.signupStatus == SignupStatus.submitting
                          ? null
                          : Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.underline)),
                  )
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
