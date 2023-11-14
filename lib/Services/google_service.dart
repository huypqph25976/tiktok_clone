import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogleService{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await auth.signInWithCredential(credential);

      // Lưu thông tin người dùng vào Firestore
      await collectionReference.doc(userCredential.user!.uid).set({
        'uID': userCredential.user!.uid,
        'username': userCredential.user!.displayName ?? '',
        'email': userCredential.user!.email ?? '',
        'avartarURL': userCredential.user!.photoURL,
        'follower': [],
        'following': [],
        'idTopTop': '@${createName(userCredential.user!.email)}',
        // Thêm các thông tin khác nếu cần
      });

      return userCredential.user;
    } catch (error) {
      print(error);
      return null;
    }
  }
  String createName(String? email) {
    if (email != null && email.isNotEmpty) {
      int atIndex = email.indexOf('@');
      if (atIndex != -1 && atIndex < email.length - 1) {
        String domain = email.substring(0, atIndex);
        return domain;
      }
    }
    return ""; // Trả về giá trị mặc định nếu không có email hoặc không tìm thấy '@'
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
