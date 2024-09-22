import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apptrial3/models/usermodel.dart';

class AuthenticationProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        phoneNumber: userCredential.user!.phoneNumber ?? '',
        name: userCredential.user!.displayName ?? '',
      );

      notifyListeners();
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }
  Future<void> signUpWithEmailAndPassword(
      String email,
      String password,
      String phoneNumber,
      Function(String) onVerificationIdReceived,
      ) async {
    try {
      //Create user with email and password
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      //Start phone number verification
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //Automatically sign in if verification completed
          //This sign in method does not link the user created by email and password
          //to fireauth phonenumber user
          //User is redirected to login page
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) {
          //Pass the verificationId to the callback
          onVerificationIdReceived(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          //Handle timeout
        },
      );
    } catch (e) {
      throw e;
    }
  }


  Future<void> verifyPhoneNumber(String verificationId, String smsCode) async {
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
