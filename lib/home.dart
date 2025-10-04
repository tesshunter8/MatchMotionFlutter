import 'package:flutter/material.dart';
import 'package:untitled/library.dart';
import 'package:untitled/settings.dart';
import 'package:untitled/signin.dart';
import 'package:untitled/test.dart';
import 'package:untitled/video.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List <Widget> screens=[LibraryScreen(), VideoScreen(), SettingsScreen()];
  int currentPage=0;
  void changePage(int chosenPage){
    setState(() {
      currentPage=chosenPage;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(onTap:changePage,currentIndex: currentPage,
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.videocam),label: "Videos"),
        BottomNavigationBarItem(icon: Icon(Icons.upload),label: "Upload New Video"),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings")
      ]),
      body: screens[currentPage],
    );
  }
}
