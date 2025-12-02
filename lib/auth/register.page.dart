import 'package:flutter/material.dart';
import '../services/auth.service.dart';
import 'package:diario_aventuras/auth/login.page.dart';

//declarando que o widget é mudavel, statefull
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // objetos de armazenar texto digitado nos input de email e senha...
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // executa cadastro
  void _signup(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Aqui você chama o AuthService (se já tiver criado)
    final user = await AuthService().signup(email, password);

    // Por enquanto, só imprime no console
    print('Cadastrando: $email / $password');
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
      appBar: AppBar(title: const Text('Register')),
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
              onPressed: () => _signup(context),
              child: const Text('Register'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Clique para login'),
            ),
          ],
        ),
      ),
    );
  }
}
