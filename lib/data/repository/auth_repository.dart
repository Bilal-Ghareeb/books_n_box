import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../helper/exceptions.dart';
import '../../utils/constants/firestore_fields.dart';
import '../models/user.dart';
import 'user_data_cache.dart';

class AuthRepository {
  AuthRepository({
    UserDataCache? userDataCache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? fireStore,
  })  : _userDataCache = userDataCache ?? UserDataCache(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _fireStore = fireStore ?? FirebaseFirestore.instance;

  final UserDataCache _userDataCache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _fireStore;

  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _userDataCache.writeUserDataCachePreferences(user);

      return user;
     });
  }

  User get currentUser {
    return _userDataCache.readUserDataCachePreferences();
  }

  Future<void> registerEmailAccount({required String email, required String confirmedPassword , required String displayName}) async {
    try {
      final userCredential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: confirmedPassword
      );
      await userCredential.user?.updateDisplayName(displayName);
    } on firebase_auth.FirebaseAuthException catch (exception) {
      throw FirebaseAuthFailure.fromCode(exception.code);
    } catch (e) {
      throw FirebaseAuthFailure();
    }
  }

  Future<void> loginWithEmailPassword({required String email, required String password}) async {
    try {
      await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on firebase_auth.FirebaseAuthException catch (exception) {
      throw FirebaseAuthFailure.fromCode(exception.code);
    } catch (e) {
      throw FirebaseAuthFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    late final firebase_auth.AuthCredential credential;
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw GoogleSignInFailure(e.code);
    }
    catch (_){
      throw GoogleSignInFailure();
    }
  }

  void saveFireStoreUser(User user) {
    if (user.isAuthenticated) {
      _fireStore.collection(kUsersCollectionName).doc(user.id)
          .set({kUserNameField: user.name ?? "", kUserEmailField: user.email});
    }
  }

  Future<bool> isNewAccount(String userId) async {
    bool exists = false;
    try {
      await _fireStore.collection(kUsersCollectionName).doc(userId).get().then((doc) {
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetUserPasswordWithEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }
    catch (error){
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      _userDataCache.writeUserDataCachePreferences(User.empty);
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, profilePicturePath: photoURL);
  }
}
