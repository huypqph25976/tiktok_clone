import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone2/Providers/loginphoneprovider.dart';

class VerifyOTP extends StatelessWidget {
  const VerifyOTP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text("Enter the code",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 35)
                      ,),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                         Text('${Provider.of<LoginPhoneProvider>(context, listen: false)
                        .textEditingController.text}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),),
                        const SizedBox(
                          width: 10,
                        ),

                      ],
                    )
                  ],
                ),

            )
          ],
        ),
      ),
    );
  }
}
