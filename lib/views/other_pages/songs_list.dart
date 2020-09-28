import 'dart:io';
import 'package:dio/dio.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:abulfadhwl_frontend/models/song.dart';
import 'package:abulfadhwl_frontend/models/album.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abulfadhwl_frontend/providers/songs_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:abulfadhwl_frontend/constants/more_button_constants.dart';
import 'package:abulfadhwl_frontend/views/other_pages/now_playing_screen_sheet.dart';

typedef BottomSheetCallback = void Function();

class SongsList extends StatefulWidget {
  final List<Song> songs;
  final String title;
  final Album initials;
  final SongsProvider songProvider;

  const SongsList({
    Key key,
    @required this.songs,
    @required this.title,
    @required this.songProvider,
    @required this.initials,
  }) : super(key: key);

  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";
  BottomSheetCallback _showMyBottomSheetCallBack;
  Song playingSong;
  int newIndex;

  @override
  void initState() {
    _showMyBottomSheetCallBack = _showBottomSheet;
    widget.songProvider.initAudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple[800],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.deepPurple[800]),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: widget.songs.isEmpty
                ? Center(
                    child: Text("Audio bado hazijawekwa"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 1.5, right: 5),
                          child: InkWell(
                            focusColor: Colors.blue,
                            splashColor: Colors.red,
                            onTap: () {
                              widget.songProvider.stop();
                              widget.songProvider.play(api +
                                  'song/file/' +
                                  widget.songs[index].id.toString());
                              setState(() {
                                widget.songProvider.isPlaying;
                                widget.songProvider.currentSongFile = api +
                                    'song/file/' +
                                    widget.songs[index].id.toString();
                                widget.songProvider.currentSongTitle =
                                    widget.songs[index].title;
                                widget.songProvider.currentSongDescription =
                                    widget.songs[index].description;
                                newIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: newIndex == index
                                    ? Colors.orange[200]
                                    : Colors.orange[100],
                              ),
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.music_note,
                                  color: Colors.orange[700],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 10, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.songs[index].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.deepPurple[800],
                                              fontWeight: FontWeight.bold,
                                              fontStyle: newIndex == index
                                                  ? FontStyle.italic
                                                  : FontStyle.normal),
                                        ),
                                        Text(
                                          widget.songs[index].description,
                                          style: TextStyle(
                                              color:  Colors.deepPurple,
                                              fontSize: 12,
                                              fontStyle: newIndex == index
                                                  ? FontStyle.italic
                                                  : FontStyle.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: newIndex == index
                                      ? Icon(
                                          FontAwesomeIcons.play,
                                          color: Colors.orange[700],
                                        )
                                      : PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.orange[700],
                                          ),
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: Colors.orange[50],
                                          onSelected: choiceAction,
                                          itemBuilder: (_) {
                                            widget.songProvider.songIndex =
                                                index;
                                            return MoreButtonConstants.choices
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .deepPurple[800],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.songs.length,
                    ),
                  ),
          ),
          widget.songs.isEmpty
              ? Container()
              : InkWell(
                  onTap: () {
                    _showMyBottomSheetCallBack();
                  },
                  child: Container(
                    color: Colors.white,
                    height: 60,
                    child:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Container(
                        height: 40,
                        width: 35,
                        child: Image(
                          color: Colors.orange[700],
                          image: AssetImage("assets/icons/music.png"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.songProvider.currentSongTitle,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.deepPurple[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.songProvider.currentSongDescription,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: widget.songProvider.isPlaying
                            ? IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.pause,
                                  size: 30,
                                  color: Colors.orange[700],
                                ),
                                onPressed: () {
                                  widget.songProvider.pause();
                                  setState(() {
                                    widget.songProvider.isPaused;
                                  });
                                })
                            : IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.play,
                                  size: 30,
                                  color: Colors.orange[700],
                                ),
                                onPressed: () {
                                  widget.songProvider.play(
                                      widget.songProvider.currentSongFile);
                                  setState(() {
                                    widget.songProvider.isPlaying;
                                  });
                                }),
                      ),
                    ]),
                  ),
                )
        ],
      ),
    );
  }

  void _showBottomSheet() {
    setState(() {
      _showMyBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return NowPlayingScreenSheet(
            playingSongTitle: widget.songProvider.currentSongTitle,
            playingSongDescription: widget.songProvider.currentSongDescription,
            playingSongFile: widget.songProvider.currentSongFile,
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showMyBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  void choiceAction(String choice) {
    if (choice == MoreButtonConstants.PlayAudio) {
      widget.songProvider.stop();
      widget.songProvider.play(api +
          'song/file/' +
          widget.songs[widget.songProvider.songIndex].id.toString());
      setState(() {
        newIndex = widget.songProvider.songIndex;
        widget.songProvider.isPlaying;
        widget.songProvider.currentSongTitle =
            widget.songs[widget.songProvider.songIndex].title;
        widget.songProvider.currentSongDescription =
            widget.songs[widget.songProvider.songIndex].description;
      });
    } else if (choice == MoreButtonConstants.ShareAudio) {
      Share.share(api +
          'song/file/' +
          widget.songs[widget.songProvider.songIndex].id.toString());
    } else
      downloadFile(
          api +
              'song/file/' +
              widget.songs[widget.songProvider.songIndex].id.toString(),
          widget.songs[widget.songProvider.songIndex].title);
  }

  Future<void> downloadFile(songUrl, songFileName) async {
    Dio dio = Dio();
    try {
      Directory downloadsDirectory = await getExternalStorageDirectory();
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      await dio.download(
          songUrl, downloadsDirectory.path + "/" + songFileName + ".mp3",
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
}
