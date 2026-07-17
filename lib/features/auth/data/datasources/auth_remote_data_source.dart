import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Talks to Firebase Auth + Firestore's `users/{uid}` collection. Only
/// constructed/used when [FirebaseBootstrap.isAvailable] is true — see
/// [AuthRepositoryImpl] for the offline fallback path.
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: const ['email']);

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _fetchOrCreateProfile(user);
    });
  }

  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Saver',
      photoUrl: user.photoURL,
      isChildMode: user.isAnonymous,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(displayName);
      final model = UserModel(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        isChildMode: false,
        createdAt: DateTime.now(),
      );
      await _users.doc(model.id).set(model.toJson());
      return model;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign up failed');
    }
  }

  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _fetchOrCreateProfile(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _fetchOrCreateProfile(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign-in failed');
    }
  }

  Future<UserModel> signInAsChild({required String displayName}) async {
    try {
      final credential = await _auth.signInAnonymously();
      await credential.user?.updateDisplayName(displayName);
      final model = UserModel(
        id: credential.user!.uid,
        email: '',
        displayName: displayName,
        isChildMode: true,
        createdAt: DateTime.now(),
      );
      await _users.doc(model.id).set(model.toJson());
      return model;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Could not start kid mode');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Could not send reset email');
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<UserModel> _fetchOrCreateProfile(fb.User user) async {
    final doc = await _users.doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    final model = UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Saver',
      photoUrl: user.photoURL,
      isChildMode: user.isAnonymous,
      createdAt: DateTime.now(),
    );
    await _users.doc(user.uid).set(model.toJson());
    return model;
  }
}
