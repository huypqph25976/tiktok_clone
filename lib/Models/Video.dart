
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
}