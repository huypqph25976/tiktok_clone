class UserModel {
  String username;
  String password;
  String email;
  String phone;
  List<String>? follower;
  List<String>? follows;
  List<String>? bookmark;
  List<String>? notification;
  String avatarURL;
  String bio;
  DateTime lastActive;
  bool isOnline;

  UserModel(
      {required this.username,
      required this.password,
      required this.email,
      required this.phone,
      required this.avatarURL,
      required this.bio,
      this.follower,
      this.follows,
      this.bookmark,
      this.notification,
        required this.lastActive,
      this.isOnline = false,
      });
}
