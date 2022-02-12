// ignore_for_file: prefer__ructors, prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerPageIOS extends StatefulWidget {
  ImagePickerPageIOS({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ImagePickerPageIOSState createState() => _ImagePickerPageIOSState();
}

class _ImagePickerPageIOSState extends State<ImagePickerPageIOS> {
  List<AssetEntity> assets = [];
  late AssetEntity selectedModel;
  File? image;

  @override
  void initState() {
    _getImages();
    super.initState();
  }

  void _getImages() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    setState(() {
      assets = recentAssets
          .where((element) => element.type == AssetType.image)
          .toList();
      selectedModel = assets.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                //SizedBox(width: 10),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton<FileModel>(
                //     items: getItems() as List<DropdownMenuItem<FileModel>>?,
                //     onChanged: (FileModel? d) {
                //       assert(d!.files.isNotEmpty);
                //       image = d!.files[0] as File;
                //       setState(() {
                //         selectedModel = d as AssetEntity;
                //       });
                //     },
                //     value: selectedModel,
                //   ),
                // ),
                // ],
                // ),
                Spacer(),
                InkWell(
                  child: Padding(
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
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image != null
                    ? Image.file(image!,
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width)
                    : Container()),
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4),
                  itemBuilder: (_, i) {
                    var file = assets[i];
                    return GestureDetector(
                      child: AssetThumbnail(asset: assets[i]),
                      onTap: () async {
                        image = (await file.file)!;
                        setState(() {});
                      },
                    );
                  },
                  itemCount: assets.length),
            )
          ],
        ),
      ),
    );
  }

// List<FileModel> files = <FileModel>[];
//
// List<DropdownMenuItem> getItems() {
// return files
//         .map((e) => DropdownMenuItem(
//               child: Text(
//                 e.folder,
//                 style: TextStyle(color: Colors.black),
//               ),
//               value: e,
//             ))
//         .toList() ??
//     [];
// }
}

class AssetThumbnail extends StatelessWidget {
  AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
