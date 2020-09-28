import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/providers/songs_provider.dart';
import 'package:share/share.dart';

class NowPlayingScreenSheet extends StatefulWidget {
  final String playingSongTitle;
  final String playingSongDescription;
  final String playingSongFile;

  const NowPlayingScreenSheet(
      {Key key,
      @required this.playingSongTitle,
      @required this.playingSongDescription,
      @required this.playingSongFile})
      : super(key: key);

  @override
  _NowPlayingScreenSheetState createState() => _NowPlayingScreenSheetState();
}

class _NowPlayingScreenSheetState extends State<NowPlayingScreenSheet> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";

  @override
  Widget build(BuildContext context) {
    final _songObject = Provider.of<SongsProvider>(context);
    return Container(
      key: _scaffoldKey,
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
                          widget.playingSongTitle,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.playingSongDescription,
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
                      widget.playingSongFile,
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
                if (_songObject.duration != null)
                  Padding(
                    padding: EdgeInsets.only(top: 248),
                    child: Slider(
                        inactiveColor: Colors.orange[200],
                        activeColor: Colors.orange[700],
                        value:
                            _songObject.position?.inMilliseconds?.toDouble() ??
                                0.0,
                        onChanged: (double value) {
                          setState(() {
                            return _songObject.audioPlayer
                                .seek((value / 1000).roundToDouble());
                          });
                        },
                        min: 0.0,
                        max: _songObject.duration.inMilliseconds.toDouble()),
                  ),
              ],
            ),
            if (_songObject.position != null)
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _songObject.position != null
                          ? "${_songObject.positionText ?? ''}"
                          : _songObject.duration != null
                              ? _songObject.durationText
                              : '',
                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                    ),
                    Text("${_songObject.durationText ?? ''}",
                        style:
                            TextStyle(fontSize: 12, color: Colors.orange[700]))
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
                    child: _songObject.isPlaying
                        ? IconButton(
                            icon: Icon(
                              FontAwesomeIcons.pause,
                              size: 30,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              _songObject.pause();
                              setState(() {
                                _songObject.isPaused;
                              });
                            })
                        : IconButton(
                            icon: Icon(
                              FontAwesomeIcons.play,
                              size: 30,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              _songObject.play(widget.playingSongFile);
                              setState(() {
                                _songObject.isPlaying;
                              });
                            }),
                  ),
                  Expanded(
                    child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.orange[700],
                        ),
                        onPressed: () {}),
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
                _songObject.downloadFile(
                    widget.playingSongFile, widget.playingSongTitle);
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
