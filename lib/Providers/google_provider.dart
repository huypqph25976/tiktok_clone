import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Services/google_service.dart';

class SignInWithGoogleProvider extends ChangeNotifier{
  final SignInWithGoogleService service = SignInWithGoogleService();
  User? _user;

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    _user = await service.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signOut() async {
    await service.signOut();
    _user = null;
    notifyListeners();
  }
}