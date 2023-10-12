import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Services/authServices.dart';

class RegisterEmail extends StatelessWidget {
  RegisterEmail({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  String? validateEmail(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (!isValidEmail(value)) {
      return "Wrong Email !";
    } else {
      return null;
    }
  }

  doRegister(BuildContext context) {
    if (validate()) {
      AuthService.registerFetch(
          context: context,
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          uid: ''
      );
    }
  }

  bool validate() {
    if (usernameController.text.isNotEmpty && emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length <= 5) {
      return "Your password is so short !";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != passwordController.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register with Email',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),

        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Username",
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                    enabledBorder: OutlineInputBorder(),
                  ),

                ),
                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Colors.black),
                    enabledBorder: OutlineInputBorder(),
                  ),

                ),

                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Password",
                    prefixIcon: Icon(Icons.key, color: Colors.black),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  obscureText: true,

                ),

                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.key, color: Colors.black),
                    enabledBorder: OutlineInputBorder(),
                  ),
                  obscureText: true,

                ),

                const SizedBox(width: 20),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {

                      doRegister(context);
                    },
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
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }
}
