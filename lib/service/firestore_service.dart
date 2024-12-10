import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference musics =
      FirebaseFirestore.instance.collection('musics');

  // Função para criar uma nova música
  Future<void> createMusic(String musicName, String artist, String album) {
    return musics.add({
      'musicName': musicName,
      'artist': artist,
      'album': album,
      'timestamp': Timestamp.now(),
    });
  }

  // Função para ler as músicas
  Stream<QuerySnapshot> readMusics() {
    return musics.orderBy('timestamp', descending: true).snapshots();
  }

  // Função para atualizar uma música
  Future<void> updateMusic(String docID, String newMusicName, String newArtist, String newAlbum) {
    return musics.doc(docID).update({
      'musicName': newMusicName,
      'artist': newArtist,
      'album': newAlbum,
      'timestamp': Timestamp.now(),
    });
  }

  // Função para excluir uma música
  Future<void> deleteMusic(String docID) {
    return musics.doc(docID).delete();
  }
}
