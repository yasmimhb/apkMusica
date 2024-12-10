import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musica/components/my_button.dart';
import 'package:musica/components/my_textfield.dart';
import 'package:musica/view/home_page.dart';
import 'package:musica/view/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false; 

  void login() async {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      showAlert("Por favor, preencha todos os campos.");
      return;
    }

    setState(() {
      _isLoading = true;
      
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text, 
        password: passwordController.text
      );
      
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage())
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; 
      });

      String errorMessage = _getErrorMessage(e.code);
      showAlert(errorMessage); 
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showAlert("Ocorreu um erro inesperado: $e");
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "O e-mail informado é inválido.";
      case 'user-not-found':
        return "Usuário não encontrado. Verifique seu e-mail.";
      case 'wrong-password':
        return "Senha incorreta. Tente novamente.";
      default:
        return "Ocorreu um erro inesperado. Tente novamente.";
    }
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
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
                            const SizedBox(height: 60.0),
                            const Icon(
                              Icons.music_note,
                              size: 100.0,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 30.0),
                            Text(
                              'Bem-vindo ao MusicApp',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  MyButton(
                                    onTap: _isLoading ? null : login,
                                    text: _isLoading ? "Entrando..." : "Entrar",
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Não tem conta?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    ' Registre-se agora!',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
