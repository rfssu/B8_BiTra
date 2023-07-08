
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/model_auth.dart';

class AuthController{
 final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference userCollection = 
  FirebaseFirestore.instance.collection('users');

  bool get success => false;


 Future<UserModel?> registerWithEmailAndPassword(
      String userName, String email, String password, String role) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final UserModel newUser = UserModel(
            userName: userName,
            email: user.email ?? '',
            uId: user.uid,
            role: role);

        await userCollection.doc(newUser.uId).set(newUser.toMap());

        return newUser;
      }
    } catch (e) {
      print('Error registering user: $e');
    }

    return null;
  }


  //Login
   Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await userCollection.doc(user.uid).get();

        final UserModel currentUser = UserModel(
            userName: snapshot['userName'] ?? '',
            email: user.email ?? '',
            uId: user.uid,
            role: snapshot['role']);

        return currentUser;
      }
    } catch (e) {
      print('Error signing in: $e');
    }

    return null;
  }

  UserModel? getCurrentUser() {
    final User? user = auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }




}

