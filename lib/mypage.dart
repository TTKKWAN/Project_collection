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
                      Icon(Icons.person, size: 30,),
                      Text('nickname',
                        //context.watch<UserStore>().users[context.watch<UserStore>().mypageid]['nickname'],
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
                      //Text(context.watch<UserStore>().users[context.watch<UserStore>().mypageid]['userLevel']),
                      Text('[Member]',
                        style:TextStyle(fontWeight: FontWeight.w500, fontSize: 20),)
                    ],),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                child: Container(
                  child: Row(

                    children: [
                      Icon(Icons.location_on_outlined, size: 30,),
                      Text('Name of Community',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      //Text(context.watch<UserStore>().users[context.watch<UserStore>().mypageid]['community'])
                    ],
                  ),
              ),),
              Container(
                child: Text('My Activities', style: TextStyle(
                  fontSize: 30,
                ),),

              ),
              //Store1 data에 있는 nickname으로 구분해서 게시물 가져옴
              Expanded(
                child: ListView.builder(
                    itemCount: widget.data.length,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        child: ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text('my activity'),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.removedata(i);
                                });
                              },
                              icon: Icon(Icons.delete)),
                        ),
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (c) => detailPage()));
                        },
                      );
                    }),
              )

            ],

          )
        );
  }
}