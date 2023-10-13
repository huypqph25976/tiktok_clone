import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginwithemail.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginwithphone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login to Tick Tock",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: const Text(
                    "Manage your account, check notifications, \ncomment on videos, and more",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )),

              // phone login button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginWithPhone()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Login with phone number",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),

              // email login button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginWithEmail()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Login with Email",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Don't have an account? Sign up.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
