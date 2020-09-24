import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:abulfadhwl_frontend/models/song.dart';
import 'package:abulfadhwl_frontend/providers/songs_provider.dart';
import 'package:share/share.dart';

class NowPlayingScreenSheet extends StatefulWidget {
  final Song playingSong;

  const NowPlayingScreenSheet({Key key, @required this.playingSong})
      : super(key: key);

  @override
  _NowPlayingScreenSheetState createState() => _NowPlayingScreenSheetState();
}

class _NowPlayingScreenSheetState extends State<NowPlayingScreenSheet> {
  // AudioPlayer audioPlayer = new AudioPlayer();

  Duration _duration = new Duration();
  Duration _position = new Duration();
   final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";
  String _songUrl, _songFileName;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final _songObject = Provider.of<SongsProvider>(context);
    return Container(key: _scaffoldKey,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 60,
              child: Row(children: <Widget>[
                Container(
                  height: 40,
                  width: 25,
                  child: Icon(
                    Icons.music_note,
                    color: Colors.orange[700],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.playingSong.title,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.playingSong.description,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.orange[700],
                  icon: Icon(FontAwesomeIcons.share),
                  onPressed: () {
                    Share.share(
                      api +
                          'song/song_file/' +
                          widget.playingSong.id.toString(),
                    );
                  },
                ),
              ]),
            ),
            Stack(
              children: <Widget>[
                Card(
                  elevation: 10,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "شيخ أبو الفضل قاسم مفوتا قاسم",
                            style: TextStyle(
                                color: Colors.deepPurple[800],
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "حفظه الله ورعاه",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.orange[50].withOpacity(0.5),
                            child: Icon(
                              FontAwesomeIcons.music,
                              size: 110,
                              color: Colors.orange[100].withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 200, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: _songObject.changeShuffleIcon
                                  ? IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: Colors.orange[700],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _songObject.changeShuffleIcon =
                                              !_songObject.changeShuffleIcon;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _songObject.changeShuffleIcon =
                                              !_songObject.changeShuffleIcon;
                                        });
                                      },
                                    ),
                            ),
                            Container(
                              child: _songObject.changeRepeatIcon == 0
                                  ? IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.repeat,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _songObject.changeRepeatIcon++;
                                        });
                                      },
                                    )
                                  : _songObject.changeRepeatIcon == 1
                                      ? IconButton(
                                          iconSize: 30,
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: Colors.orange[700],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _songObject.changeRepeatIcon++;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          iconSize: 30,
                                          icon: Icon(
                                            Icons.repeat,
                                            color: Colors.orange[700],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _songObject.changeRepeatIcon =
                                                  _songObject.changeRepeatIcon -
                                                      2;
                                            });
                                          },
                                        ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 248),
                  child: Slider(
                    inactiveColor: Colors.orange[200],
                    activeColor: Colors.orange[700],
                    value: _position.inSeconds.toDouble(),
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (double value) {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '1:18',
                    style: TextStyle(fontSize: 10, color: Colors.orange[700]),
                  ),
                  Text('-2:59',
                      style: TextStyle(fontSize: 10, color: Colors.orange[700]))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.orange[700],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    child: _songObject.changePlayIcon==false
                        ? IconButton(
                            icon: Icon(
                              FontAwesomeIcons.play,
                              size: 30,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              _songUrl=api+'song/file/'+widget.playingSong.id.toString();
                              _songFileName=widget.playingSong.title;
                              // _songObject.play(_songUrl);
                              setState(() {
                                _songObject.changePlayIcon =
                                    !_songObject.changePlayIcon;
                              });
                            })
                        : IconButton(
                            icon: Icon(
                              FontAwesomeIcons.pause,
                              size: 30,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              // _songObject.pause();
                              // setState(() {
                              //   _songObject.changePlayIcon =
                              //       !_songObject.changePlayIcon;
                              // });
                            }),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.orange[700],
                      ),
                      onPressed: () {
                        
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              elevation: 5,
              color: Colors.orange[700],
              icon: Icon(
                FontAwesomeIcons.download,
                color: Colors.deepPurple[800],
                size: 17,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: Text(
                'PAKUA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                downloadFile(_songUrl, _songFileName);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> downloadFile(_songUrl, _songFileName) async {
    Dio dio = Dio();
    try {
      Directory downloadsDirectory = await getExternalStorageDirectory();
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      await dio.download(
          _songUrl, downloadsDirectory.path + "/" + _songFileName + ".mp3",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec, Total: $total");
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
        print(downloadsDirectory.path);

        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                Text(
                  "Downloading... $progressString",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            action: progressString == "100%"
                ? SnackBarAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: "Close",
                  )
                : null));
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }
  // void initPlayer() {
  //   audioPlayer = new AudioPlayer();
  //   audioPlayer.onDurationChanged.listen((Duration d) {
  //     setState(() {
  //       _duration = d;
  //     });
  //   });

  //   audioPlayer.onAudioPositionChanged.listen((Duration p) {
  //     setState(() {
  //       _position = p;
  //     });
  //   });
  // }
}
