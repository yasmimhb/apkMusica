import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musica/firebase_options.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
