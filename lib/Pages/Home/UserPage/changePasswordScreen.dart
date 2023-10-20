import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/userProfileScreen.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final String currentPassword = _currentPasswordController.text;
        final String newPassword = _newPasswordController.text;
        final String confirmPassword = _confirmPasswordController.text;

        if (newPassword == confirmPassword) {
          final credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
          await user.reauthenticateWithCredential(credential);

          // Thay đổi mật khẩu
          await user.updatePassword(newPassword);

          // Hiển thị thông báo thành công
           showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Password changed successfully.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen()
                          ),
                      );


                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Hiển thị thông báo lỗi
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('New password and confirm password do not match.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                hintText: "Current Password",
                prefixIcon: Icon(Icons.key, color: Colors.black),
                enabledBorder: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                hintText: "New Password",
                prefixIcon: Icon(Icons.lock_reset, color: Colors.black),
                enabledBorder: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_reset, color: Colors.black),
                enabledBorder: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}