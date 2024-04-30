import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:qolshatyr_mobile/src/providers/auth_provider.dart';
import 'package:qolshatyr_mobile/src/utils/form_validation.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/auth_widgets.dart';

enum Status { login, signUp }

Status type = Status.login;

class LoginScreen extends StatefulWidget {
  static const routename = '/auth';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isLoading = false;

  void _toggleLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _toggleType() {
    setState(() {
      type = type == Status.login ? Status.signUp : Status.login;
    });
  }

  Future<void> _performAuthentication(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() authenticationFunction,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // TODO: loading animation
    _toggleLoading(true);
    await authenticationFunction().whenComplete(() {
      ref.watch(authServiceProvider).authStateChange.listen((event) {
        if (event == null) {
          _toggleLoading(false);
          return;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Consumer(builder: (context, ref, _) {
                final auth = ref.watch(authServiceProvider);

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        flex: type == Status.login ? 4 : 8,
                        child: Container(
                          margin: const EdgeInsets.only(top: 48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 250,
                                  child: Image.asset('assets/qolshatyr.png'),
                                ),
                              ),
                              const Spacer(flex: 1),
                              AuthInputField(
                                controller: _email,
                                hintText: 'Email address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: LoginFormValidation.validateEmail,
                              ),
                              AuthInputField(
                                controller: _password,
                                hintText: 'Password',
                                icon: Icons.lock_rounded,
                                validator: LoginFormValidation.validatePassword,
                                isPassword: true,
                              ),
                              if (type == Status.signUp)
                                AuthInputField(
                                  controller: _confirmPassword,
                                  hintText: 'Confirm password',
                                  icon: Icons.lock_rounded,
                                  validator: (value) => LoginFormValidation
                                      .validateConfirmPassword(
                                    value,
                                    _password.text,
                                  ),
                                  isPassword: true,
                                ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AuthButton(
                                onPressed: () => _performAuthentication(
                                  context,
                                  ref,
                                  () => type == Status.login
                                      ? auth.signInWithEmailAndPassword(
                                          _email.text,
                                          _password.text,
                                          context,
                                        )
                                      : auth.signUpWithEmailAndPassword(
                                          _email.text,
                                          _password.text,
                                          context,
                                        ),
                                ),
                                label:
                                    type == Status.login ? 'Log in' : 'Sign up',
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: type == Status.login
                                        ? 'Don\'t have an account? '
                                        : 'Already have an account? ',
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: type == Status.login
                                            ? 'Sign up now'
                                            : 'Log in',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = _toggleType,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
