import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutterfire_trial0/models/custom_error.dart';
import 'package:flutterfire_trial0/pages/signup_page.dart';
// import 'package:flutterfire_trial0/providers/auth/auth_provider.dart';
import 'package:flutterfire_trial0/providers/signin/signin_provider.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../providers/signin/signin_state.dart';
import '../utils/error_dialog.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const routeName = '/signin';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

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
          .read<SigninProvider>()
          .signin(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninProvider>().state;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: (() => FocusScope.of(context).unfocus()),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
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
                    ElevatedButton(
                      child: Text(
                          signinState.signinStatus == SigninStatus.submitting
                              ? 'Loading...'
                              : 'Sign in'),
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
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
                      child: Text('Sign up now!'),
                      onPressed: () {
                        signinState.signinStatus == SigninStatus.submitting
                            ? null
                            : Navigator.pushNamed(
                                context, SignupPage.routeName);
                      },
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
