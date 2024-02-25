import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'signin.dart';
import 'package:tttoy/signin.dart';
import 'util.dart';

class Mypage extends StatefulWidget {
  Mypage({super.key, this.data, this.removedata});
  final data;
  final removedata;

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //그 사람을 어떻게 인식해서 id를 인식할 수 있을까
        //title: context.watch<UserStore>().users[context.watch<UserStore>().mypageid]['nickname'],

        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.person_pin,
                  size: 40,
                ),
                Text(
                  'Jason Brown',
                  // context.read<UserStore>().users[0]['nickname'],
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  context.read<UserStore>().users[0]['userLevel'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 30,
                ),
                Text("GDSC OF KOREA",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
          ),
        ),
        Container(
          child: Text(
            "My Activity",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Container(
            height: 0.5,
            width: 500.0,
            color: Colors.black,
          ),
        ),
        //Store1 data에 있는 nickname으로 구분해서 게시물 가져옴
        Expanded(
          child: ListView.separated(
            itemCount: widget.data.length,
            itemBuilder: (c, i) {
              return GestureDetector(
                child: ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text(widget.data[i]['title']),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.removedata(i);
                        });
                      },
                      icon: Icon(Icons.delete)),
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => detailPage()));
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        )
      ],
    ));
  }
}
