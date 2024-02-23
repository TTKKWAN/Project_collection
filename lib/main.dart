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

//https://server-irxa6nl5aa-uc.a.run.app/

void main() {
  runApp(ChangeNotifierProvider(create: (_) => UserStore(), child: MaterialApp(home: SignIn()),)
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
  var data = [];
  var userImage;
  var userContent = ['0', '0'];
  var newlike = 0;

  setUserContent(i, a) {
    setState(() {
      if (i == 0) {
        newlike = a;
      } else if (i == 1) {
        userContent[0] = a;
      } else {
        userContent[1] = a;
      }
    });
  }

  //저 URL에서 데이터 get하고 result에 저장, 그걸 json형식으로 decode해서 result2에 저장, data에 result2 저장.
  //예시 url에서 data가져오는 코드인데 참고만 해야할듯
  Future<void> getData() async {
    final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6InNlYmluIiwiaWF0IjoxNzA4NTI5OTI2LCJleHAiOjE3MDg1NDc5MjZ9.0CE4nDRBMEeGSTOHNzbuYEchrZs7PrwbFvcOQQL1WQY";

    var url = Uri.parse('https://server-irxa6nl5aa-uc.a.run.app/boards/');
    var subdata;
    try {
      var response = await http.get(
          url,
          headers: <String, String>{
            'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        subdata = jsonDecode(response.body);
        print('getData success');
      }
      setState(() {
        data = subdata;
      });
    } catch (e) {
      print('error');
    }
  }


  //새로운 board 만드는 함수,
  Future<void> addMyData() async {
    final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6InNlYmluIiwiaWF0IjoxNzA4NTM3NTIzLCJleHAiOjE3MDg1NTU1MjN9.JZxRCrKXWci_iWFKNnJ_k6Myp1vtMQfUS7j5_wYT-dA";
    var url = Uri.parse('https://server-irxa6nl5aa-uc.a.run.app/boards/');

    var myData = {

        "title": "title1",
        "content": "content1",
        "location": "anam",
        "photos": ["photo1"]



      // 'title': userContent[0],
      // 'content': userContent[1],
      // 'location': "anam",
      // 'photos': userImage,
      // 'hearts': newlike,
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode((myData))
      );
      if (response.statusCode == 200) {
        print('addMyDataSuccess');
      } else {
        print("fail");
      }
    } catch (e) {
      print('addMyDataError');
    }

    setState(() {
      data.insert(0, myData);
    });
  }

  Future<void> removedata(boardIdd) async {
    final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuaWNrbmFtZSI6InNlYmluIiwiaWF0IjoxNzA4NTI5OTI2LCJleHAiOjE3MDg1NDc5MjZ9.0CE4nDRBMEeGSTOHNzbuYEchrZs7PrwbFvcOQQL1WQY";
    final boardId = boardIdd;
    final url = Uri.parse(
        'https://server-irxa6nl5aa-uc.a.run.app/boards/$boardId');

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
        child: Icon(Icons.edit),
        backgroundColor: Colors.white,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // 앱바 높이 조절
        child: Custombar(), ///////////////// 커스텀 앱바 적용
      ),
      body: data.isEmpty // 로딩 중일 때 하얀색 화면
          ? const Padding(
              padding: EdgeInsets.only(top: 200),
              child:
                  Text("hello", style: TextStyle(fontSize: 20, color: Colors.grey)),
            ) //
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
        ChangeNotifierProvider(create: (c) => UserStore(), child: Mypage(
            removedata: removedata,
            data: data
        ),)
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
          // Text('이미지 업로드 화면'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(userImage),
          ),
          TextField(
            onChanged: (text) {
              setUserContent(0, int.parse(text));
            },
            decoration: InputDecoration(labelText: ' 좋아요 수'),
          ),
          TextField(
            onChanged: (text) {
              setUserContent(1, text);
            },
            decoration: InputDecoration(labelText: ' 글쓴이 이름'),
          ),
          TextField(
            onChanged: (text) {
              setUserContent(2, text);
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
