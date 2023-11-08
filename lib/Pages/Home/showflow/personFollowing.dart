import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../../Services/userService.dart';

class PersonFollowing extends StatefulWidget {
  const PersonFollowing({super.key, required this.OtherID});

  final String OtherID;

  @override
  State<PersonFollowing> createState() => _PersonFollower();
}

class _PersonFollower extends State<PersonFollowing> {


  var searchKeyword = "";
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
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
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users').doc(widget.OtherID).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                      itemCount: snapshot.data!['following'].length,
                      itemBuilder: (BuildContext context, int index) {
                        String followingId = snapshot.data!['following'][index].toString();
                        DocumentReference followingRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(followingId);
                        return FutureBuilder<DocumentSnapshot>(future: followingRef.get(), builder: (context,followingDoc){

                          if(followingDoc.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          }
                          else{
                            Map<String, dynamic> item =
                            followingDoc.data!.data() as Map<String, dynamic>;
                            return Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        child: ClipRRect(

                                          child: Image.network(
                                            item['avartarURL'], width: 60, height: 60,fit: BoxFit.cover,),
                                          borderRadius: BorderRadius.circular(30),

                                        ),
                                      ),
                                      const SizedBox(height: 75, width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Các widget con được xếp chồng lên nhau theo thứ tự được định
                                          Text(
                                            item['username'], style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 18,),),
                                          const SizedBox(width: 5,),
                                          // const SizedBox(width: 100,),

                                          Text(
                                            item['bio'], style: TextStyle(

                                              fontSize: 13,color: Color(0xff777777)),),
                                          const SizedBox(width: 5,),
                                        ],
                                      )


                                      // const SizedBox(width: 100,),

                                      // RaisedButton(
                                      //   onPressed: () {
                                      //     // Xử lý khi nút được nhấn
                                      //   },
                                      //   child: Text('Nút 1'),
                                      // ),
                                    ],


                                  ),
                                  const SizedBox(width: 30,),

                                  // ElevatedButton(
                                  //     onPressed: () {
                                  //       UserService.follow(item['uID']);
                                  //     },
                                  //     child:  !snapshot.data?.get('following').contains(uid) ?
                                  //     const Text(
                                  //       "Đang Follow",
                                  //       style: TextStyle(
                                  //         fontSize: 15, color: Colors.white, ),
                                  //     ) :
                                  //     const Text(
                                  //       "Follow",
                                  //       style: TextStyle(
                                  //         fontSize: 15, color: Colors.white, ),
                                  //     )
                                  //
                                  // ),
                          ElevatedButton(
                          onPressed: ()
                          {
                          setState(() {
                            UserService.follow(item['uID']);
                          });
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 40),),
                            child: !item['uID'].contains(uid)
                                ? const Text(
                              "Follow  ",
                                style: TextStyle(
                                  fontSize: 15,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.person_3),

                          )
                                ],
                              ),
                            );

                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }


}
