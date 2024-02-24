import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (c) => Store1(),
      child: MaterialApp(theme: style.theme, home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent = ['0', '0', '0'];

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');

    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    // var result = storage.getString('name');
    var result = storage.getString('map') ?? '없는데요';
    print(jsonDecode(result));
  }

  setUserContent(i, a) {
    setState(() {
      if (i == 0) {
        userContent[0] = a;
      } else if (i == 1) {
        userContent[1] = a;
      } else {
        userContent[2] = a;
      }
    });
  }

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': userContent[0],
      'date': 'july 25',
      'content': userContent[1],
      'user': userContent[2]
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = (jsonDecode(result.body));
    setState(() {
      data = result2;
    });
  }

  @override
  void initState() {
    super.initState();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(title: Text('Instagram'), actions: [
        IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(
                  source: ImageSource.gallery); //ImageSource.camera도 가능.
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => Upload(
                            userImage: userImage,
                            setUserContent: setUserContent,
                            addMyData: addMyData,
                          ) //scafold 시작해서 rayout 집어넣으면 됨.
                      ));
            },
            iconSize: 30)
      ]),
      body: [
        Home(
          data: data,
          addData: addData,
        ),
        Text('샵페이지')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        }, // onPressed랑 똑같음.
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

///////////////////////////////////////upload state/////////////////////////
class Upload extends StatelessWidget {
  Upload({super.key, this.userImage, this.setUserContent, this.addMyData});
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                addMyData();
                Navigator.pop(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: [
          Text('이미지 업로드 화면'),
          Image.file(userImage),
          TextField(
            onChanged: (text) {
              setUserContent(0, text.toString());
            },
            decoration: InputDecoration(hintText: '좋아요 수'),
          ),
          TextField(
            onChanged: (text) {
              setUserContent(1, text);
            },
            decoration: InputDecoration(hintText: '글쓴이 이름'),
          ),
          TextField(
            onChanged: (text) {
              setUserContent(2, text);
            },
            decoration: InputDecoration(hintText: '내용'),
          ),
        ],
      ),
    );
  }
}

var gang = [
  'rain.webp',
  'tramp.jpg',
  'dog.jpg',
];

///////////////////////////// home state/////////////////////////////
class Home extends StatefulWidget {
  // 등록은 statefull
  Home({Key? key, this.data, this.addData}) : super(key: key);

  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 사용은 stateless

  var data2 = [];
  var plus = 0;

  var scroll = ScrollController();

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more2.json'));
    var result2 = (jsonDecode(result.body));
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      // 스크롤한 거리 == 최대 스크롤 거리
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[index]['image'].runtimeType == String
                    ? Image.network(widget.data[index]['image'])
                    : Image.file(widget.data[index]['image']),
                Text(
                  '좋아요 : ${widget.data[index]['likes'].toString()}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  child: Text(widget.data[index]['user']),
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (c) => Profile()));
                  },
                ),
                Text(widget.data[index]['content'].toString())
              ],
            );
          });
    } else {
      return Text('로딩중임');
    }
  }
}

/////////////profile state/////////////////////////////////////////
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store1>().name)),
      body: ListTile(
          leading: Icon(
            Icons.supervised_user_circle_sharp,
            size: 30,
          ),
          title: Row(children: [
            Text('팔로워 ' + context.watch<Store1>().follower.toString() + '명'),
          ]),
          trailing: ElevatedButton(
              onPressed: () {
                context.read<Store1>().changeName();
              },
              child: Text('팔로우'))),
    );
  }
}

////////////state 보관함 /////////////////////////////////////
class Store1 extends ChangeNotifier {
  var name = 'john kim';
  var follower = 0;
  var f = 0;

  changeName() {
    if (f % 2 == 0) {
      follower++;
    } else {
      follower--;
    }
    f++;
    notifyListeners();
  }
}
