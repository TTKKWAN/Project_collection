import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'util.dart';
import 'text.dart';

List<String> lst = [
  'camera.jpg',
  'balcony.jpg',
  'rain.webp',
  'desk.jpg',
];

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ////// 여기는 그냥 데이터 로드 부분
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> listComponent = [];
  Future<void> _loadData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      listComponent = prefs.getStringList("listComponent") ?? [];
    });
  } //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return menuComponent(context, listcontent, index);
        });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 1;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Vote for Revoot',
        style: TextStyle(fontSize: 30),
      )),
      body: [Text('Top 10'), Home(), Text('my page')][tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        selectedItemColor: Color.fromARGB(255, 97, 22, 134),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        }, // onPressed랑 똑같음.
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.ten_mp), label: 'Top 10'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded), label: '마이 페이지')
        ],
      ),
    );
  }
}
