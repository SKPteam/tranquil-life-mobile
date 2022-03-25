// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:storage_path/storage_path.dart';
import 'package:tranquil_life/models/file_model.dart';

class ImagePickerAndroid extends StatefulWidget {
  const ImagePickerAndroid({Key? key}) : super(key: key);

  @override
  _ImagePickerAndroidState createState() => _ImagePickerAndroidState();
}

class _ImagePickerAndroidState extends State<ImagePickerAndroid> {
  List<FileModel> files = <FileModel>[];
  FileModel? selectedModel;
  String image = "";
  bool loaded = false;
  bool noImagesInSelectedModel = false;
  @override
  void initState() {
    super.initState();
    //getImagesPath();
  }

  // getImagesPath() async {
  //   //Directory tempDir = await getTemporaryDirectory();
  //   var imagePath = await StoragePath.imagesPath;
  //   var images = jsonDecode(imagePath!) as List;
  //   files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
  //   print(files);
  //   if (files.isNotEmpty) {
  //     setState(() {
  //       selectedModel = files[0];
  //       image = files[0].files[0];
  //       loaded = true;
  //     });
  //   }
  // }

  List<DropdownMenuItem<FileModel>> getItems() {
    return files
        .map((e) => DropdownMenuItem(
      child: Text(
        e.folder.toString(),
        style: TextStyle(color: Colors.black),
      ),
      value: e,
    ))
        .toList();
    // .toList() ??
    // [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loaded
            ? Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<FileModel>(
                          items: getItems(),
                          onChanged: (FileModel? d) {
                            if (d!.files.length > 0) {
                              image = d.files[0];
                              setState(() {
                                selectedModel = d;
                              });
                            } else {
                              setState(() {
                                noImagesInSelectedModel = true;
                              });
                            }
                          },
                          value: selectedModel,
                        ))
                  ],
                ),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(image);
                  },
                )
              ],
            ),
            const Divider(),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image.isNotEmpty
                    ? Image.file(File(image),
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width)
                    : Container()),
            const Divider(),
            selectedModel == null && noImagesInSelectedModel
                ? const Center(
              child: Text(
                'No Images Found',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            )
                : SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4),
                  itemBuilder: (_, i) {
                    var file = selectedModel!.files[i];
                    return GestureDetector(
                      child: Image.file(
                        File(file),
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        setState(() {
                          image = file;
                        });
                      },
                    );
                  },
                  itemCount: selectedModel!.files.length),
            )
          ],
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}