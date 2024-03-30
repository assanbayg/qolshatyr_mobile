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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          children: [
            const Text('Already have an account?'),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ))
          ],
        )
      ],
    ));
  }
}
