import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginwithemail.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginwithphone.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {

  signInWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;


    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    if(userCredential.user != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(),),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  child: Image.asset("images/tiktok.png", height: 100,),
                ),
                const Text("Login to TiK Tok",
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold
                ),),

                Container(
                    margin: const EdgeInsets.only(top: 10,bottom: 20),
                   child: const Text("Manage your account, check notifications, \ncomment on videos, and more",
                  style: TextStyle(
                      fontSize: 16,color: Colors.grey,
                  ),)),

                // phone login button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                 child: Column(
                   children: [
                     ElevatedButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWithPhone()));

                     },style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.grey
                     ), child: const Padding(
                       padding:  EdgeInsets.all(15.0),
                       child: Row(
                         children: [
                           Icon(Icons.phone,color: Colors.black,),
                           SizedBox(width: 20,),
                           Text("Login with phone number",
                             style: TextStyle(
                                 fontSize: 14, color: Colors.black),)
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
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithEmail()));
                      },style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey
                      ), child: const Padding(
                        padding:  EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(Icons.email,color: Colors.black,),
                            SizedBox(width: 20,),
                            Text("Login with Email",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),)
                          ],
                        ),
                      ))
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: (){
                        signInWithGoogle();
                      },style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey
                      ), child: const Padding(
                        padding:  EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(Icons.public,color: Colors.black,),
                            SizedBox(width: 20,),
                            Text("Login with Google",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),)
                          ],
                        ),
                      ))
                    ],
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
