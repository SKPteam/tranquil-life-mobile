class ChatroomMessage {
  final String message;
  final String chatroomID;
  final String senderID;
  final String senderAvatarUrl;
  final String id;
  final String quote;
  final bool isRead;
  final DateTime timestamp;
  late messagetype type;
  final int secondsOfAudio;

  ChatroomMessage(
      {this.message = '',
        required this.chatroomID,
        required this.id,
        this.isRead = false,
        this.senderAvatarUrl = '',
        this.quote = '',
        this.secondsOfAudio = 0,
        required this.timestamp,
        required this.senderID,
        required String type}) {
    this.type = messagetypeFromText(type);
  }

  static messagetype messagetypeFromText(String type) {
    switch (type) {
      case 'text':
        return messagetype.text;
        break;
      case 'audio':
        return messagetype.audio;
        break;
      case 'image':
        return messagetype.image;
        break;
      default:
        return messagetype.text;
    }
  }
}

enum messagetype { text, audio, image }