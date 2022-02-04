// ignore_for_file: file_names

class JournalModel {
  final String id;
  final String heading;
  final String body;
  final String moodSvgUrl;
  final DateTime timestamp;

  JournalModel(
      {this.heading = '',
        this.body = '',
        this.moodSvgUrl = '',
        required this.timestamp,
        required this.id});
}