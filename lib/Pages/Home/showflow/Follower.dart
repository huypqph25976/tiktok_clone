import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Follower extends StatefulWidget {
  const Follower({super.key});

  @override
  State<Follower> createState() => _Follower();
}

class _Follower extends State<Follower> {


  var searchKeyword = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 15, 10, 10),
                width: double.infinity,
                height: 50,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Nhập vào từ khóa cần tìm...',
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = snapshot.data!.docs[index];
                      return Card(
                        child: Row(
                          children: [
                            ClipRRect(
                              child: Image.network(
                                item['avartarURL'], width: 100, height: 100,),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            const SizedBox(height: 100, width: 10,),
                            Text(
                              item['username'], style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,),),
                            const SizedBox(width: 5,),
                            const SizedBox(width: 100,),

                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }


}
