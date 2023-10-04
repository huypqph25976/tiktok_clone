import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VideoService{
  static likeVideo(String id) async {
    DocumentSnapshot doc =
    await FirebaseFirestore.instance.collection('videos').doc(id).get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static likeComment(String videoID, String commentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('comments')
        .doc(commentId)
        .get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static checkLike(String id) {}
}