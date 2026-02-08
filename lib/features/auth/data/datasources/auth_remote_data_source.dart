import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String name);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    log('doc.data(): ${doc.data()}');
    return UserModel.fromJson({...doc.data()!, 'id': credential.user!.uid});
  }

  @override
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(id: credential.user!.uid, email: email, name: name);
    await firestore.collection('users').doc(user.id).set(user.toJson());
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await googleSignIn.initialize(
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );
    final googleUser = await googleSignIn.authenticate(scopeHint: ['email']);
    final authClient = googleUser.authorizationClient;
    final authorization = await authClient.authorizationForScopes(['email']);
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: authorization?.accessToken,
      idToken: googleUser.authentication.idToken,
    );
    final userCredential = await firebaseAuth.signInWithCredential(credential);

    final doc = await firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    if (!doc.exists) {
      final user = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? '',
      );
      await firestore.collection('users').doc(user.id).set(user.toJson());
      return user;
    }
    return UserModel.fromJson({...doc.data()!, 'id': userCredential.user!.uid});
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({...doc.data()!, 'id': user.uid});
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await firestore.collection('users').doc(user.id).update(user.toJson());
  }
}
