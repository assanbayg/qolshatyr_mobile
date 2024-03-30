import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/qolshatyr.png'),
        Text(
          'Welcome to Qolshatyr!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text('Already have an account?')
      ],
    ));
  }
}
