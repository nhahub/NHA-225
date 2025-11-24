import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  /// 🔹 Reference to Firestore users collection
  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        );
  }

  /// 🔹 Add user to Firestore
  static Future<void> addUserToFirestore(UserModel user) async {
    await getUsersCollection().doc(user.id).set(user);
  }

  /// 🔹 Read user from Firestore by ID (old method)
  static Future<UserModel?> readUserFromFireStore(String id) async {
    var querySnapshot = await getUsersCollection().doc(id).get();
    return querySnapshot.data();
  }

  /// 🔹 NEW: Cleaner alias method for readability
  static Future<UserModel?> getUserById(String userId) async {
    var userSnapshot = await getUsersCollection().doc(userId).get();
    return userSnapshot.data();
  }

  /// 🔹 Get user by email
static Future<UserModel?> getUserByEmail(String email) async {
  final querySnapshot = await getUsersCollection()
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.data();
  } else {
    return null; 
  }
}

  /// 🔹 Google Sign-in
  Future<UserCredential> signInWithGoogle() async {
    // Initialize Google Sign-In
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "27268841055-nl4sa62bl67m7hmdrg1425bo78963a9n.apps.googleusercontent.com",
    );

    // Authenticate user
    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();

    // Obtain the auth details
    final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

    // Create new Firebase credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  
}
