import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiktok_clone2/Pages/Home/Notification/NotificationService.dart';

class VideoService {
  static likeVideo(String id, String idOther) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot docUser =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
      NotificationsService().sendNotification(
          title: "New notification",
          body:
              'Bạn vừa nhận 1 lượt thích từ ${(docUser.data()! as dynamic)['username']}',
          idOther: idOther,
          avartarUrl: '${(docUser.data()! as dynamic)['avartarURL']}');
    }
  }

  static bookmarkVideo(String videoId) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(uid);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        List<String> bookmark =
            List<String>.from(userSnapshot['bookmark'] ?? []);

        if (bookmark.contains(videoId)) {
          bookmark.remove(videoId);
        } else {
          bookmark.add(videoId);
        }

        await userDoc.update({
          'bookmark': bookmark,
        });
      }
    }
  }

  static bookmarkUserVideo() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookmark')
        .snapshots();
  }

  static likeComment(String videoID, String commentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .collection('commentList')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  static checkLike(String id) {}

  static updateComment(String videoID, String commentId, String comment) async {
    return await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .update({'content': comment});
  }

  static deleteComment(String videoID, String commentId) async {
    return await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .doc(commentId)
        .delete();
  }
}
