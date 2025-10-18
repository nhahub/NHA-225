  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_sign_in/google_sign_in.dart';


    FirebaseAuth auth = FirebaseAuth.instance ;



  class AuthService {
    static Future<UserCredential> register ({required String email , required String password , required String username}) async {

      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      await user.user!.updateDisplayName(username); 
      
        return user;
    }

    Future<UserCredential?> login ({required String email , required String password }) async {

      
      var user = await auth.signInWithEmailAndPassword(email: email, password: password);
      return user;
      }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
      await GoogleSignIn.instance.initialize(
      serverClientId: "27268841055-nl4sa62bl67m7hmdrg1425bo78963a9n.apps.googleusercontent.com"
    );
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  }