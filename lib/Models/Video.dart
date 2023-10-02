
import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  String username;
  String uid;
  String id;
  List likes;
  List comments;
  int shareCount;
  String songName;
  String songCaption;
  String videoUrl;
  String profilePhoto;
  String thumbnail;

  Video(
  {required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.comments,
    required this.shareCount,
    required this.songName,
    required this.songCaption,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail});

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "profilePhoto": profilePhoto,
    "id": id,
    "likes": likes,
    "comments": comments,
    "shareCount": shareCount,
    "songName": songName,
    "caption": songCaption,
    "videoUrl": videoUrl,
    "thumbnail": thumbnail
  };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      comments: snapshot['comments'],
      shareCount: snapshot['shareCount'],
      songName: snapshot['songName'],
      songCaption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      profilePhoto: snapshot['profilePhoto'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}