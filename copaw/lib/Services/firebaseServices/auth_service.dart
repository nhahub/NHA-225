import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copaw/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // This method returns a reference to the users collection in Firestore.
  // It uses a converter to convert between Firestore data and MyUser objects.
  static CollectionReference<UserModel> getUsersCollection() {
    // Access the users collection in Firestore and set up a converter
    // to convert Firestore documents to MyUser objects and vice versa.
    return FirebaseFirestore
        .instance // Access the Firestore instance
        .collection(UserModel.collectionName) // Access the users collection
        .withConverter<UserModel>(
          // Use a converter to convert between Firestore data and MyUser objects
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toJson(),
        );
  }

  // This method adds a user to the Firestore database.
  // It takes a MyUser object and saves it to the users collection.
  static Future<void> addUserToFirestore(UserModel user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  // This method reads a user from Firestore based on their ID.
  // It returns a MyUser object if found, or null if not found.
  static Future<UserModel?> readUserFromFireStore(String id) async {
    var querySnapshot = await getUsersCollection().doc(id).get();
    return querySnapshot.data();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "27268841055-nl4sa62bl67m7hmdrg1425bo78963a9n.apps.googleusercontent.com",
    );
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
