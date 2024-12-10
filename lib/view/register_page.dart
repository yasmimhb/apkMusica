import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musica/components/my_button.dart';
import 'package:musica/components/my_textfield.dart';
import 'package:musica/view/auth_page.dart';
import 'package:musica/view/home_page.dart';
import 'package:musica/view/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Flag para o loading durante o cadastro

  // Função para registrar o usuário
void register() async {
  setState(() {
    _isLoading = true; // Ativa o loading
  });

  // Verificando se as senhas são iguais
  if (passwordController.text == confirmPasswordController.text) {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text, password: passwordController.text);
      Navigator.pop(context); // Fecha o loading

      // Após a criação bem-sucedida, navegue para a próxima tela
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Fecha o loading em caso de erro
      print(e.code);

      // Lógica para diferentes erros
      switch (e.code) {
        case 'email-already-in-use':
          showAlert("Já existe um usuário com esse email!");
          break;
        case 'weak-password':
          showAlert("A senha deve ter pelo menos 6 caracteres.");
          break;
        default:
          showAlert("Erro inesperado: ${e.message}");
      }
    }
  } else {
    Navigator.pop(context); // Fecha o loading
    showAlert("Senhas não conferem!");  // Exibe erro se as senhas não coincidirem
  }
}

void showAlert(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta de erro
            },
            child: const Text('OK'),
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
                             const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Já possui conta?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Entrar!',
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
