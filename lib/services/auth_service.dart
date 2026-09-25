import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neighbor_share/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

    Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 1. Входим в Firebase Auth
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    // 2. 🟢 Если вход успешен — создаем/подгружаем профиль соседа в Firestore!
    if (user != null) {
      await UserService().getOrCreateProfile(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    }

    return userCredential;
  }


  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
