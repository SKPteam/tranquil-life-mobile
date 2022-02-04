class NotificationModel {
  final String id;
  final String msg;
  final DateTime timeAgo;
  final String? imageUrl;
  final String uid;
  late NotificationType _type;
  final String userName;
  NotificationType get type => _type;
  NotificationModel({
    required this.id,
    this.msg = '',
    required this.userName,
    required this.timeAgo,
    this.imageUrl,
    required this.uid,
    required String notificationtype,
  }) {
    switch (notificationtype) {
      case 'time':
        _type = NotificationType.time;
        break;
      case 'transaction':
        _type = NotificationType.transaction;
        break;
      case 'chat':
        _type = NotificationType.chat;
        break;
      case 'people':
        _type = NotificationType.people;
        break;
      default:
        _type = NotificationType.chat;
    }
  }
}

enum NotificationType { time, people, chat, transaction }