import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musica/service/firestore_service.dart';
import 'package:musica/view/login_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController musicNameController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController albumController = TextEditingController();

  // Função de logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Função para abrir a caixa de diálogo para adicionar/editar músicas
  void openMusicBox({String? docID, String? currentMusicName, String? currentArtist, String? currentAlbum}) {
    musicNameController.text = currentMusicName ?? '';
    artistController.text = currentArtist ?? '';
    albumController.text = currentAlbum ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: musicNameController,
              decoration: const InputDecoration(labelText: 'Nome da música'),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: 'Artista'),
            ),
            TextField(
              controller: albumController,
              decoration: const InputDecoration(labelText: 'Álbum'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.createMusic(
                  musicNameController.text,
                  artistController.text,
                  albumController.text,
                );
              } else {
                firestoreService.updateMusic(
                  docID,
                  musicNameController.text,
                  artistController.text,
                  albumController.text,
                );
              }
              musicNameController.clear();
              artistController.clear();
              albumController.clear();
              Navigator.pop(context);
            },
            child: const Text("Adicionar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.music_note),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: openMusicBox,
            child: const Icon(Icons.add),
            backgroundColor: Colors.greenAccent,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: logout,
            child: const Icon(Icons.logout),
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: StreamBuilder<User?>(  // Verifica o estado de autenticação do usuário
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Você precisa estar logado."));
          }

          return StreamBuilder<QuerySnapshot>(  // Escuta o fluxo de dados de músicas
            stream: firestoreService.readMusics(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List musicList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = musicList[index];
                    String docID = document.id;
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String musicName = data['musicName'];
                    String artist = data['artist'];
                    String album = data['album'];
                    return ListTile(
                      title: Text(musicName),
                      subtitle: Text('$artist - $album'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openMusicBox(
                              docID: docID,
                              currentMusicName: musicName,
                              currentArtist: artist,
                              currentAlbum: album,
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => firestoreService.deleteMusic(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Sem músicas..."));
              }
            },
          );
        },
      ),
    );
  }
}
