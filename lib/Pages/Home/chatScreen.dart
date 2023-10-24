import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2.1),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Chat', style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      Icon(Icons.search)
                    ],
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                

              ],
            ),
          ),

        )
    );
  }
}

