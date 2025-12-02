import 'package:diario_aventuras/auth/login.page.dart';
import 'package:flutter/material.dart';
import '../auth/auth.service.dart';

class ForgetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  ForgetPasswordPage({super.key});

  void _resetPassword(BuildContext context) async{
    final email = emailController.text.trim();

    final user = await AuthService().resetPassword(email);

    print('Enviando: $email');
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Reset password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: const Text('Reset your password'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                 Navigator.push(context, 
                 MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('Ja possui uma conta? clique para login.'),
            ),
          ],
        ),
      ),
    );
  }
}