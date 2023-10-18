class UserModel {
  String username;
  String password;
  String email;
  String phone;
  List<String>? follower;
  List<String>? follows;
  String avatarURL;
  String bio;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.avatarURL,
    required this.bio,
     this.follower,
     this.follows,
});

}