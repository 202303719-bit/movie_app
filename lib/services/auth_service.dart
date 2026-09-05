import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

/// Wraps every Firebase Auth call used by the app so the UI screens
/// never talk to `FirebaseAuth.instance` directly.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Login screen -> _login()
  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register screen -> _createAccount()
  /// Creates the auth user, sends an email-verification link, then writes
  /// the extra profile fields (name, phone, avatar) to Firestore since
  /// Firebase Auth alone only stores displayName / photoURL.
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.sendEmailVerification();

    await _firestoreService.createUserProfile(
      uid: credential.user!.uid,
      name: name,
      email: email.trim(),
      phone: phone,
      avatar: avatar,
    );

    return credential;
  }

  /// Forget password screen -> _verifyEmail()
  Future<void> sendPasswordResetEmail({required String email}) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Login screen -> _loginWithGoogle()
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Make sure a Firestore profile exists for first-time Google users.
      await _firestoreService.createUserProfileIfMissing(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        avatar: 'assets/images/avatar_1.png',
      );

      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null; // المستخدم قفل نافذة الاختيار
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Maps FirebaseAuthException codes to short user-facing messages.
  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Password is too weak.';
        default:
          return error.message ?? 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}