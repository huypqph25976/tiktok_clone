class NotificationModel {
  String title;
  String content;
  String time;
  String idUser;
  String image;

  NotificationModel(
      {required this.title,
      required this.content,
      required this.idUser,
      required this.time,
      required this.image});
}
