import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musica/components/my_button.dart';
import 'package:musica/components/my_textfield.dart';
import 'package:musica/service/auth_service.dart';
import 'package:musica/view/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void register() async {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      showAlert('As senhas não conferem.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text,
      );

      Navigator.pop(context); 
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Usuário registrado com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); 

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Este e-mail já está em uso.';
          break;
        case 'invalid-email':
          errorMessage = 'Formato de e-mail inválido.';
          break;
        case 'weak-password':
          errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
          break;
        default:
          errorMessage = 'Erro desconhecido!';
          break;
      }

      showAlert(errorMessage);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true, 
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.greenAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          const SizedBox(height: 100.0),
                          const Icon(
                            Icons.music_note,
                            size: 100.0,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            'Crie sua Conta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                MyTextfield(
                                  controller: userNameController,
                                  hintText: "E-mail",
                                  obscureText: false,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(height: 20.0),
                                MyTextfield(
                                  controller: passwordController,
                                  hintText: "Senha",
                                  obscureText: true,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(height: 20.0),
                                MyTextfield(
                                  controller: confirmPasswordController,
                                  hintText: "Confirme a Senha",
                                  obscureText: true,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(height: 20.0),
                                MyButton(
                                  onTap: register,
                                  text: "Cadastrar",
                                  textColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}