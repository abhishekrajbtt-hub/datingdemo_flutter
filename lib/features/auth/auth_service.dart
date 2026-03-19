import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({required FirebaseAuth auth}) : _auth = auth;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<UserCredential> signInWithGoogle() async {
    await _googleSignIn.initialize();
    final account = await _googleSignIn.authenticate();
    final authData = account.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authData.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> sendEmailOtp({
    required String email,
    required bool isSignUp,
  }) async {
    final callable = _functions.httpsCallable('sendEmailOtp');
    await callable.call(<String, dynamic>{
      'email': email.trim(),
      'mode': isSignUp ? 'signup' : 'login',
    });
  }

  Future<bool> verifyEmailOtp({
    required String email,
    required String code,
    required bool isSignUp,
  }) async {
    final callable = _functions.httpsCallable('verifyEmailOtp');
    final result = await callable.call(<String, dynamic>{
      'email': email.trim(),
      'otp': code.trim(),
      'mode': isSignUp ? 'signup' : 'login',
    });
    final data = result.data;
    if (data is Map && data['verified'] == true) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
