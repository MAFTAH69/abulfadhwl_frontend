import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:abulfadhwl_frontend/providers/data_provider.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:downloads_path_provider/downloads_path_provider.dart';

import 'package:path_provider/path_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool downloading = false;
  var progressString = "";
  // Directory _downloadsDirectory;

  @override
  void initState() {
    super.initState();
    // initDownloadsDirectoryState();
  }

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);

    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          title: RaisedButton(
              child: Text("Pakua"),
              onPressed: () {
                downloadFile(
                  "https://www.dropbox.com/home/DAWRAH%20KIGOMA/MIHADHARA%20MCHANGANYIKO?preview=NASAHA+ZA+KUFUNGA.mp3",
                    // api +
                    //     "book/book_cover/" +
                    //     _dataObject.books[0].bookId.toString(),
                     _dataObject.books[1].title);
              }),
        ),
        body: Center(
            child: downloading
                ? Container(
                    height: 120,
                    width: 120,
                    child: Card(
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Downloading...")
                        ],
                      ),
                    ),
                  )
                : Image(
                    image: NetworkImageWithRetry(api +
                        "book/book_cover/" +
                        _dataObject.books[1].id.toString()),
                    fit: BoxFit.cover,
                  )
            // : Text("No data")

            ));
  }

  Future<void> downloadFile(fileUrl, bookFileName) async {
    Dio dio = Dio();
    try {
      Directory downloadsDirectory = await getExternalStorageDirectory();
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      await dio.download(fileUrl, downloadsDirectory.path + "/" + bookFileName+".mp3",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec, Total: $total");
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
        print(downloadsDirectory.path);
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }
}
