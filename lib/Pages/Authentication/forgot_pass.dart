import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginscreen.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  final _formKey = GlobalKey<FormState>();

  var email = "";
  final emailCOntroller = TextEditingController();

  resetPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text('Password Reset Email has been sent!',
          style: TextStyle(fontSize: 18),),
      ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen(),),);
    } on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found'){
        print('Not user found for that email');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amber,
          content: Text('Not user found for that email', style: TextStyle(fontSize: 20, color: Colors.amber),),
        ));
      }
    }
  }

  @override
  void dispose() {
    emailCOntroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('Reset link will be send to your email ID!', style: TextStyle(fontSize: 20),),
          ),
          Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          autofocus: false,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.black26, fontSize: 15,
                              )
                          ),

                          controller: emailCOntroller,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter Email';
                            }
                            else if(!value.contains('@')){
                              return ' Please enter valid email';
                            }
                            return null;
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: (){
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  email = emailCOntroller.text;
                                });
                                resetPassword();
                              }
                            },
                              style: ElevatedButton.styleFrom(

                                backgroundColor: Colors.redAccent,
                              ),
                              child: Text('Send email',
                                style: TextStyle(fontSize: 18),),
                            ),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen(),),);
                            }, child: Text('Login', style: TextStyle(fontSize: 13),),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              )
          )
        ],
      ),
    );
  }
}