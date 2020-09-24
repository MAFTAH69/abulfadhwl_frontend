import 'package:abulfadhwl_frontend/views/screens/audios_screen.dart';
import 'package:abulfadhwl_frontend/views/screens/books_screen.dart';
import 'package:abulfadhwl_frontend/views/screens/history_screen.dart';
import 'package:abulfadhwl_frontend/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_frontend/providers/data_provider.dart';
import 'package:abulfadhwl_frontend/providers/songs_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final songCategoryProvider = Provider.of<SongsProvider>(context);
    final _dataProvider=Provider.of<DataProvider>(context);
    final List<Widget> _screens = [
      HomeScreen(dataProvider: _dataProvider,),
      BooksScreen(),
      AudiosScreen(songCategories: songCategoryProvider.categories,),
      HistoryScreen()
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        selectedItemColor: Colors.orange[700],
        unselectedItemColor: Colors.grey[600],
        onTap: tappedTab,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.book), title: Text('Books')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.microphone), title: Text('Audios')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('History'))
        ],
      ),
    );
  }

  void tappedTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
