import 'package:flutter/material.dart';
import '../services/auth.service.dart';
import 'package:diario_aventuras/auth/register.page.dart';
import 'package:diario_aventuras/auth/forget_password.page.dart';
import 'package:diario_aventuras/pages/create.page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // objetos de armazenar texto digitado nos input de email e senha...
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //as funçoes do firebase.auth ...
  void _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
        final user = await AuthService().login(email, password);
        print('Logando: $email / $password');

         if (user != null) {
      // Se o login deu certo, vai pra tela de create...
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreatePage()),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou senha incorretos')),
      );
    }

    } catch (e) {
      //
    }


  }

  //limpa objeto de armazenar texto
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Clique para registrar-se'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                );
              },
              child: const Text('Esqueceu sua senha?'),
            ),
          ],
        ),
      ),
    );
  }
}
