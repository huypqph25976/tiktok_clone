class UserModel {
  String username;
  String password;

  String email;
  String phone;
  List<String>? follower;
  List<String>? follows;
  String avatarURL;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.avatarURL,
     this.follower,
     this.follows,
});

}