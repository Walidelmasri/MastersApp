import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptrial3/models/usermodel.dart';

class AuthService {
  //Initialize firebase authentication instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//Function to signin with email and password
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        return UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          photoURL: user.photoURL ?? '',
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }
//Function to signup with email andpassword
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String phoneNumber) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        phoneNumber: phoneNumber,
        name: userCredential.user!.displayName ?? '',
      );
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }
//Function to verify OTP with firebase
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }
  //Function to handle the password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  //Function to getUserId for creation of collections according to userId
  static String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}
