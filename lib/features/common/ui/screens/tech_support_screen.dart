// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/auth/auth_provider.dart';
import 'package:qolshatyr_mobile/features/common/services/email_service.dart';

class TechSupportScreen extends StatefulWidget {
  static const routeName = "/tech-support";
  const TechSupportScreen({super.key});

  @override
  State<TechSupportScreen> createState() => _TechSupportScreenState();
}

class _TechSupportScreenState extends State<TechSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameEditingController = TextEditingController();
  final _titleEditingController = TextEditingController();
  final _contentEditingController = TextEditingController();

  Future<void> _submitForm(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authService = ref.read(firebaseAuthProvider);

      await sendEmail(
        senderEmail: authService.currentUser!.email ?? 'unknown@gmail.com',
        subject: _titleEditingController.text,
        body: _contentEditingController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully')),
      );
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _nameEditingController.dispose();
    _titleEditingController.dispose();
    _contentEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tech Support')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeader(),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Report the problem to the developers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Icon(Icons.support_agent, size: 80),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildNameField(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 20),
            _buildProblemDescriptionField(),
            const SizedBox(height: 20),
            Consumer(builder: (context, ref, child) {
              return ElevatedButton(
                onPressed: () async => _submitForm(ref),
                child: const Text('Submit'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameEditingController,
      decoration: _inputDecoration("Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleEditingController,
      decoration: _inputDecoration("Title"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email title';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  Widget _buildProblemDescriptionField() {
    return TextFormField(
      controller: _contentEditingController,
      decoration: _inputDecoration('Problem Description'),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please describe the problem';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
