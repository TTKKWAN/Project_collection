import 'package:flutter/material.dart';
import 'list_0.dart';
import 'my_page.dart';
import 'topten.dart';

class BasicApp extends StatefulWidget {
  const BasicApp({Key? key}) : super(key: key);

  @override
  BasicAppState createState() => BasicAppState();
}

class BasicAppState extends State<BasicApp> {
  int _selectedIndex = 1; // 처음 시작했을 때 어디부터 시작할 것인가.

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const ToptenList(),
      const MenuList(), // 여기서 바꿔야 리스트랑, 캘린더 내용도 바뀜
      const MyApp(),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 210, 241, 225),
      appBar: AppBar(
        title: const Text('Vote For Reboot',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromARGB(255, 58, 132, 1),
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          )
        ],
        centerTitle: false,
        backgroundColor: Color.fromARGB(255, 150, 244, 187),
        surfaceTintColor: Color.fromARGB(255, 126, 234, 130),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 120, 219, 163).withOpacity(0.5),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromARGB(255, 103, 202, 224),
        selectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          // 바텀 바 순서만 바꾸는거임.
          BottomNavigationBarItem(
            icon: Icon(Icons.ten_mp_outlined),
            label: 'top_10',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag_faces_rounded),
            label: 'My_page',
          ),
        ],
      ),
    );
  }
}
