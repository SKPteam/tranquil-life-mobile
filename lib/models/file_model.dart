// file is a model in profile view and chat-room

// ignore_for_file: file_names

class FileModel {
  List<String> files = <String>[];
  String folder = "";

  FileModel({required this.files, required this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}