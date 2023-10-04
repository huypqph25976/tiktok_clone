
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Services/userService.dart';
import 'package:tiktok_clone2/Widgets/customText.dart';

class Tab1 extends StatelessWidget {
  const Tab1({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService.getUserInfo(),
         builder: (BuildContext context, AsyncSnapshot snapshot) {
           if (snapshot.hasError) {
             return const Text("error");
           }
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           }

           return  SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                  CustomText(
                    alignment: Alignment.center,
                    fontsize: 20,
                    text: 'Username: ',
                    color: Colors.black,
                    fontWeight: 1,
                  ),

                 CustomText(
                   alignment: Alignment.center,
                   fontsize: 20,
                   text: '${snapshot.data.get('username')}',
                   color: Colors.pink,
                   fontWeight: 1,
                 ),

                 const SizedBox(height: 20,),

                 CustomText(
                   alignment: Alignment.center,
                   fontsize: 20,
                   text: 'Email: ',
                   color: Colors.black,
                   fontWeight: 1,
                 ),

                 CustomText(
                   alignment: Alignment.center,
                   fontsize: 20,
                   text: '${snapshot.data.get('email')}',
                   color: Colors.pink,
                   fontWeight: 1,
                 ),

                 const SizedBox(height: 20,),

                 CustomText(
                   alignment: Alignment.center,
                   fontsize: 20,
                   text: 'Phone Number: ',
                   color: Colors.black,
                   fontWeight: 1,
                 ),

                 CustomText(
                   alignment: Alignment.center,
                   fontsize: 20,
                   text: '${snapshot.data.get('phone')}',
                   color: Colors.pink,
                   fontWeight: 1,
                 ),

                 const SizedBox(height: 20,),




               ],
             ),



           );
         }
      ),
    );
  }
}
