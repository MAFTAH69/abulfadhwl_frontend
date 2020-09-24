import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:abulfadhwl_frontend/providers/data_provider.dart';
import 'package:abulfadhwl_frontend/views/other_pages/home_page.dart';

class LiveDuruusAndTimetablePage extends StatefulWidget {
  @override
  _LiveDuruusAndTimetablePageState createState() =>
      _LiveDuruusAndTimetablePageState();
}

class _LiveDuruusAndTimetablePageState
    extends State<LiveDuruusAndTimetablePage> {
  @override
  void initState() {
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple[800],
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Home();
            }));

            FlutterRadio.stop();
          },
        ),
        title: Text(
          'Live Duruus na Ratiba',
          style: TextStyle(color: Colors.deepPurple[800]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  _dataObject.streams[0].title.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          _dataObject.streams[0].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold),
                        ),
                  Text(
                    _dataObject.streams[0].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          color: Colors.orange,
                          iconSize: 40,
                          icon: Icon(FontAwesomeIcons.pause),
                          onPressed: () {
                            String liveRadioUrl = _dataObject.streams[0].url;
                            FlutterRadio.pause(url: liveRadioUrl);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: IconButton(
                          color: Colors.orange,
                          iconSize: 40,
                          icon: Icon(FontAwesomeIcons.play),
                          onPressed: () {
                            String liveRadioUrl = _dataObject.streams[0].url;

                            FlutterRadio.stop();
                            FlutterRadio.play(url: liveRadioUrl);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30,top:5, right: 30),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 4 / 8,
                  backgroundColor: Colors.orange[100].withOpacity(0.5),
                  child: Image(
                    image: AssetImage("assets/icons/live.png"),
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "RATIBA YA DARSA ZA  'AAM",
              style: TextStyle(
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Image(
                    image: NetworkImageWithRetry(api +
                        'stream/timetable/' +
                        _dataObject.streams[0].id.toString())),
              ),
            )
          ],
        ),
      ),
    );
  }
}
