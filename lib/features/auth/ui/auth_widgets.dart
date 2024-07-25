// Flutter imports:
import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? isPassword;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff129f9f);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: isPassword ?? false,
        style: const TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          icon: Icon(icon, color: primaryColor, size: 24),
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : MaterialButton(
              onPressed: onPressed,
              textColor: primaryColor,
              textTheme: ButtonTextTheme.primary,
              minWidth: 100,
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: primaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' $label',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
    );
  }
}
