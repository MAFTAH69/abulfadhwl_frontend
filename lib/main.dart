import 'package:abulfadhwl_frontend/views/initial_pages/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/providers/songs_provider.dart';
import 'package:abulfadhwl_frontend/providers/data_provider.dart';


void main() => runApp(Abulfadhwl());

class Abulfadhwl extends StatefulWidget {
  @override
  _QassimState createState() => _QassimState();
}

class _QassimState extends State<Abulfadhwl> {
  final SongsProvider _songsProvider = SongsProvider();
  final DataProvider _dataProvider = DataProvider();

  @override
  void initState() {
    super.initState();

    _songsProvider.getAllCategories();
    _dataProvider.getAllBooks();
    _dataProvider.getAllHistories();
    _dataProvider.getAllSlides();
    _dataProvider.getAllArticles();
    _dataProvider.getAllAnnouncements();
    _dataProvider.getAllStreams();
    _dataProvider.getAllLinks();
    _dataProvider.getAllAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _songsProvider,
        ),
        ChangeNotifierProvider.value(
          value: _dataProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Abul Fadhwl App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: AnimatedSplashScreen(),
       
      ),
    );
  }
}
