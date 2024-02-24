import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'util.dart';
import 'package:http/http.dart' as http;
import 'signin.dart';
import 'Topten.dart';
import 'main_app_bar.dart';
import 'mypage.dart';
import 'signup.dart';

//https://server-irxa6nl5aa-uc.a.run.app/

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => UserStore(),
    child: MaterialApp(home: MyApp()),
  )
      //home: SignIn()
      );
}

class Home extends StatefulWidget {
  Home({Key? key, this.data, this.removedata}) : super(key: key);

  final data;
  final removedata;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ////// 여기는 그냥 데이터 로드 부분

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  // 구성요소
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 5 / 14,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 232, 249, 233),
                          border: Border.all(
                              color: Color.fromARGB(255, 181, 244, 187),
                              width: 1.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: menuComponent(
                          data: widget.data[index],
                        ),
                      ),
                    ],
                  )));
        });
  }
}

///////////////////////////////////////////////////////////////////
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 1;

  // List<Map<String, dynamic>> data = [
  //   {
  //     "title": "title1",
  //     "content": "content1",
  //     "location": "anam",
  //     "photos": ["photo1"]
  //   }
  // ];

  List<dynamic> data = [
    {
      "title": "title1",
      "content": "content1",
      "location": "anam",
      "photos": ["photo1"]
    }
  ];

  var userImage1;
  var userImage2;

  Future<void> getData() async {
    ////////// 여기가 제일 중요
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6IjEyMzQ1IiwiaWF0IjoxNzA4Nzc1NDYwLCJleHAiOjE3MDg3OTM0NjB9.CfPcOZxpe8MWFJUAbsQGSNYIYUzckaxmQslNYsufvG8";
    var url = Uri.parse('http://10.0.2.2:8080/boards/');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    setState(() {
      data = json.decode(response.body);
    });
  } //////////////// 여기가 제일 중요

  //새로운 board 만드는 함수,
  Future<void> addMyData(
      String newtitle, String newcontent, photopath1, photopath2) async {
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6IjEyMzQ1IiwiaWF0IjoxNzA4Nzc1NDYwLCJleHAiOjE3MDg3OTM0NjB9.CfPcOZxpe8MWFJUAbsQGSNYIYUzckaxmQslNYsufvG8";
    var url = Uri.parse('http://10.0.2.2:8080/boards/');

    File imageFile = File(photopath1.toString());
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image1 = base64Encode(imageBytes);

    File imageFile2 = File(photopath2.toString());
    List<int> imageBytes2 = imageFile2.readAsBytesSync();
    String base64Image2 = base64Encode(imageBytes2);

    var myData = {
      "title": newtitle,
      "content": newcontent,
      "location": "newanam",
      "photos": ['$base64Image1', '$base64Image2']
    };

    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode((myData)));
      if (response.statusCode == 200) {
        print('addMyDataSuccess');
      } else {
        print("fail");
      }
    } catch (e) {
      print('addMyDataError');
    }

    getData();
    // setState(() {
    //   data.insert(0, myData); // 일단 여기 뺐음 오후 3 : 25
    // });
  }

  Future<void> removedata(boardIdd) async {
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6IjEyMzQ1IiwiaWF0IjoxNzA4Nzc1NDYwLCJleHAiOjE3MDg3OTM0NjB9.CfPcOZxpe8MWFJUAbsQGSNYIYUzckaxmQslNYsufvG8";
    final boardId = boardIdd;
    final url = Uri.parse('http://10.0.2.2:8080/boards/$boardId');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Board with ID $boardId deleted successfully.');
      } else {
        print('Failed to delete board. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    getData();
  }

  void initState() {
    super.initState();
    getData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var picker = ImagePicker();
          var image = await picker.pickImage(
              source: ImageSource.gallery); //ImageSource.camera도 가능.
          if (image != null) {
            setState(() {
              userImage1 = File(image.path);
            });
          }
          var picker2 = ImagePicker();
          var image2 = await picker2.pickImage(
              source: ImageSource.gallery); //ImageSource.camera도 가능.
          if (image2 != null) {
            setState(() {
              userImage2 = File(image2.path);
            });
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => Upload(
                        userImage1: userImage1,
                        userImage2: userImage2,
                        addMyData: addMyData,
                      ) //scafold 시작해서 rayout 집어넣으면 됨.
                  ));
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.white,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // 앱바 높이 조절
        child: Custombar(), ///////////////// 커스텀 앱바 적용
      ),
      body:
          // data.isEmpty // 로딩 중일 때 하얀색 화면
          data.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Text("hello",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                )
              : [
                  Topten(
                    data: data,
                    //addData: addData,
                    removedata: removedata,
                  ),
                  Home(
                    data: data,
                    //addData: addData,
                    removedata: removedata,
                  ),
                  ChangeNotifierProvider(
                    create: (c) => UserStore(),
                    child: Mypage(removedata: removedata, data: data),
                  )
                ][tab],
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
    ));
  }
}

///////////////////////////////여기서부터 다른파일로 들어가야 할 부분 //////////////////////////////////////////////////
class Upload extends StatefulWidget {
  Upload({
    super.key,
    this.userImage1,
    this.userImage2,
    this.addMyData,
  });
  final userImage1;
  final userImage2;
  final addMyData;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  var insert_title;
  var insert_content;
  var user_Image1;
  var user_Image2;

  setUserContent(i, a) {
    if (i == 1) {
      insert_title = a.toString();
    } else {
      insert_content = a.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                widget.addMyData(
                    insert_title.toString(),
                    insert_content.toString(),
                    user_Image1.path,
                    user_Image2.path);
                Navigator.pop(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: [
          // Text('이미지 업로드 화면'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Image.file(
                widget.userImage1,
                width: MediaQuery.of(context).size.width * 3 / 10,
              ),
              Image.file(
                widget.userImage2,
                width: MediaQuery.of(context).size.width * 3 / 10,
              )
            ]),
          ),
          TextField(
            onChanged: (text) {
              setState(() {
                user_Image1 = widget.userImage1;
                user_Image2 = widget.userImage2;
              });
              setState(() {
                setUserContent(1, text);
              });
            },
            decoration: InputDecoration(labelText: ' 글쓴이 이름'),
          ),
          TextField(
            onChanged: (text) {
              setState(() {
                setUserContent(2, text);
              });
            },
            decoration: InputDecoration(labelText: ' 내용'),
          ),
        ],
      ),
    );
  }
}

// class deleteButton extends StatelessWidget {
//   deleteButton({super.key, this.removedata, this.index});

//   var removedata;
//   final index;
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           removedata(index);
//         },
//         icon: Icon(
//           Icons.delete,
//           color: Color.fromARGB(255, 3, 2, 2),
//           size: 20,
//         ));
//   }
// }