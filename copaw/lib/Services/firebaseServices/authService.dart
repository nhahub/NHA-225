import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<UserCredential> register({
    required String email,
    required String password,
    required String username,
  }) async {
    // إنشاء المستخدم في Firebase Auth
    var userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    
    await userCredential.user!.updateDisplayName(username);

    
    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'username': username,
      'isLeader': false,
      'projectId': null,
      'taskIds': [],
      'createdAt': DateTime.now(),
    });

    return userCredential;
  }

  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);

    
    final docRef = firestore.collection('users').doc(userCredential.user!.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'username': userCredential.user!.displayName ?? 'New User',
        'isLeader': false,
        'projectId': null,
        'taskIds': [],
        'createdAt': DateTime.now(),
      });
    }

    return userCredential;
  }
}
