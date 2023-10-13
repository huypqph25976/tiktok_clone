import 'package:flutter/material.dart';

import '../../../Services/userService.dart';
import '../../../Widgets/customText.dart';

class PersonTab1 extends StatelessWidget {
   const PersonTab1({Key? key, required this.personID}) : super(key: key);

   final String personID;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
          stream: UserService.getPerson(personID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
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
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
