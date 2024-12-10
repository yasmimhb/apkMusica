import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musica/view/home_page.dart';
import 'package:musica/view/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),  // Garantir que o Firebase está inicializado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Se a inicialização do Firebase for concluída, mostra o StreamBuilder
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomePage();  // Se o usuário estiver autenticado
                } else {
                  return LoginPage();  // Se o usuário não estiver autenticado
                }
              },
            );
          } else if (snapshot.hasError) {
            // Caso ocorra algum erro na inicialização do Firebase
            return Center(child: Text("Erro na inicialização do Firebase"));
          } else {
            // Exibe um carregando enquanto o Firebase inicializa
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
