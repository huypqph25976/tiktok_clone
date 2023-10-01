import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../../Providers/loginphoneprovider.dart';

class LoginWithPhone extends StatelessWidget {
  const LoginWithPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text("Nhập số điện thoại",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 35
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                    child: IntlPhoneField(
                      decoration: InputDecoration(
                        counterText: '',
                      ),
                    initialCountryCode: 'VN',
                    ),)


              ],
            ),)
          ],
        ),
      ),
    );


  }
}

