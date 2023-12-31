import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Video/videoProfileScreen.dart';

class PersonTab2 extends StatelessWidget {
  const PersonTab2({Key? key, required this.personID}) : super(key: key);

  final String personID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('videos')
                .where('uid', isEqualTo: personID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return  GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2/3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data!.docs[index];
                    return Card(
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VideoProfileScreen(
                                      videoID: item['id'],
                                    )),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            ClipRect(
                              child: Image.network(
                                '${item['thumbnail']}',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 5,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '${item['likes'].length}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });

            },
          ),
        ));
  }
}
