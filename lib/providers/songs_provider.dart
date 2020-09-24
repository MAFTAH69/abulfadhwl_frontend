import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:abulfadhwl_frontend/models/song_category.dart';
import 'package:http/http.dart' as http;

class SongsProvider extends ChangeNotifier {
  List<SongCategory> _categories = [];
  bool changeShuffleIcon = false;
  bool changeMoreOptionIcon = false;
  bool changePlayIcon = false;
  int changeRepeatIcon = 0;

  // getter
  List<SongCategory> get categories => _categories;

  Future<void> getAllCategories() async {
    List<SongCategory> _fetchedCategories = [];
    try {
      http.Response response = await http.get(api + 'categories');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // print(data);
        data['categories'].forEach(($category) {
          final dataSet = SongCategory.fromMap($category);
          _fetchedCategories.add(dataSet);
        });
        // print(_fetchedCategories);

        _categories = _fetchedCategories;
        print(_categories);
        print(_categories.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }

  // AudioPlayer audioPlayer = AudioPlayer();

  // play(songUrl) async {
  //   int result = await audioPlayer.play(songUrl);
  //   if (result == 1) {}
  // }

  // pause() async {
  //   int result = await audioPlayer.pause();
  //   if (result == 1) {}
  // }

  // stop() async {
  //   int result = await audioPlayer.stop();
  //   if (result == 1) {}
  // }
}
