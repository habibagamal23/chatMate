import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/login/model/login_model.dart';
import '../../features/register/model/register_model.dart';
import '../../features/register/model/user_info.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(LoginRequestBody loginRequest) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginRequest.email,
        password: loginRequest.password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided for that user.';
        default:
          throw 'Login failed. Please try again.';
      }
    } catch (e) {
      print('Login error: $e');
      throw 'An unknown error occurred during login.';
    }
  }

  Future resetPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset  error: $e');
    }
  }

  Future<User?> register(RegisterRequestBody requestBody) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: requestBody.email,
        password: requestBody.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserProfile userProfile = UserProfile(
          id: user.uid,
          name: requestBody.name,
          email: requestBody.email,
          phoneNumber: requestBody.phoneNumber,
          createdAt: DateTime.now().toIso8601String(),
          about: "New user",
          online: true,
          lastActivated: DateTime.now().toIso8601String(),
          pushToken: 'example-push-token',
        );

        await createUserProfile(userProfile);
      }

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<void> createUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userProfile.id)
          .set(userProfile.toJson());
      print('User profile created successfully!');
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }
}
