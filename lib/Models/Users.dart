class UserModel {
  String username;
  String password;

  String email;
  String phone;
  List<String>? follower;
  List<String>? follows;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,

     this.follower,
     this.follows,
});

}