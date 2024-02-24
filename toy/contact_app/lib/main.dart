import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts(); // 패키지 사용법일 뿐임.
      print(contacts);
      setState(() {
        name = contacts;
      });
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  //var a = 3; // 내 친구 수

  var like = [0, 0, 0];
  var name = [];
  var total = 3;

// 함수 만드는 법 소괄호 중괄호 ㅇㅇ
  addone() {
    setState(() {
      total++;
    });
  }

  addlist(ad) {
    setState(() {
      name.add(ad);
    });
  }

  removelist(ad) {
    setState(() {
      name.remove(ad);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DialogUI(state: total, addone: addone, addlist: addlist),
                  ],
                ); // 더 보내려면 state : a, state2 : b
              });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text(
              '총 인원 수 : ',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(name.length.toString(),
                style: TextStyle(fontSize: 25, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                getPermission();
              },
              icon: Icon(Icons.contacts))
        ],
      ),
      body: ListView.separated(
        itemCount: name.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Row(
              children: [
                Text(
                  name[i].givenName.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(name[i].phones[0].value.toString() == ''
                    ? '번호 없음'
                    : name[i].phones[0].value.toString()),
              ],
            ),
            trailing: IconButton(
                onPressed: () {
                  removelist(name[i]);
                },
                icon: Icon(Icons.restore_from_trash)),
          );
        },
        separatorBuilder: (BuildContext ctx, int idx) {
          return Divider();
        },
      ),
      // bottomNavigationBar: BottomAppBar(child: batom())
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.state, this.addone, this.addlist})
      : super(
            key:
                key); // 에러나서 const 지웠음. but 부모가 보낸 state는 read-only가 좋음. , 등록 2개면 this.state2까지
  final state; //final state2
  final addone;
  final inputData = TextEditingController();
  final inputData2 = TextEditingController();
  final addlist;
  final newperson = Contact();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Contact'),
        content: Column(
          children: [
            TextField(
                controller: inputData,
                decoration: InputDecoration(hintText: '이름')),
            TextField(
                controller: inputData2,
                decoration: InputDecoration(hintText: '번호'))
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context); //취소 버튼 눌렀을 때 다이얼로그 잘 닫힘
            },
            child: Text('cancel'), // 여기를 바꾸는 것
          ),
          OutlinedButton(
            child: const Text('OK'),
            onPressed: () {
              newperson.givenName = inputData.text;
              newperson.phones = [
                Item(label: "mobile", value: inputData2.text)
              ];
              addone();
              addlist(newperson);
              Navigator.pop(context);
            },
          )
        ]);
  }
}

class batom extends StatelessWidget {
  const batom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.chat),
            Icon(Icons.contact_page)
          ],
        ));
  }
}
