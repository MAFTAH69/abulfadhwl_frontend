import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_frontend/api.dart';
import 'package:abulfadhwl_frontend/models/song_category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

const kUrl =
    "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3";

enum PlayerState { stopped, playing, paused }

class SongsProvider extends ChangeNotifier {
  List<SongCategory> _categories = [];
  bool changeShuffleIcon = false;
  int changeIndex = 0;
  int changeRepeatIcon = 0;
  int songIndex = 0;
  String currentSongFile = kUrl;
  String currentSongTitle = "Bismillaahir Rahmaanir Rahiym";
  String currentSongDescription = "................................";
  bool downloading = false;
  var progressString = "";
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => position = p);
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        duration = audioPlayer.duration;
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();

        position = duration;
      }
    }, onError: (msg) {
      playerState = PlayerState.stopped;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
    });
  }

  Future play(file) async {
    await audioPlayer.play(file);
    playerState = PlayerState.playing;
  }

  Future pause() async {
    await audioPlayer.pause();
    playerState = PlayerState.paused;
  }

  Future stop() async {
    await audioPlayer.stop();
    playerState = PlayerState.stopped;
    position = Duration();
  }

  void onComplete() {
    playerState = PlayerState.stopped;
  }

  // Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
  //   Uint8List bytes;
  //   try {
  //     bytes = await readBytes(url);
  //   } on ClientException {
  //     rethrow;
  //   }
  //   return bytes;
  // }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
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
        downloading = true;
        progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        print(downloadsDirectory.path);
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }


  // getter
  List<SongCategory> get categories => _categories;

  Future<void> getAllCategories() async {
    List<SongCategory> _fetchedCategories = [];
    try {
      http.Response response = await http.get(api + 'categories');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['categories'].forEach(($category) {
          final dataSet = SongCategory.fromMap($category);
          _fetchedCategories.add(dataSet);
        });

        _categories = _fetchedCategories;
        print(_categories);
        print(_categories.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }
}
