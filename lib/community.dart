import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';
import 'package:http/http.dart' as http;
import 'signin.dart';
import 'signup.dart';


//멤버의 커뮤니티 찾기
class gradeMember extends StatefulWidget {
  const gradeMember({super.key});

  @override
  State<gradeMember> createState() => _gradeMemberState();
}

class _gradeMemberState extends State<gradeMember> {

  var communitySearch = TextEditingController();
  var mycommunity;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Scaffold(
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text('Hello {nickname}, what community do you belong to?',
                      //context.read<UserStore>().users[context.read<UserStore>().mypageid]['nickname']
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),),
                  ),
                  Padding(padding: EdgeInsets.all(40),
                    child: TextField(
                      controller: communitySearch,
                      decoration: InputDecoration(
                          icon: IconButton(icon: Icon(Icons.search),
                            onPressed: (){
                              mycommunity = context.read<UserStore>().searchData(communitySearch.text);
                            },),
                          hintText: 'Search'
                      ),
                    ),),
                  GestureDetector(child: ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text('My Community'),),
                    //Text(context.read<UserStore>().users[context.read<UserStore>().mypageid]['community']),),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c) => MyApp()));
                    },),
                ],
              ),
            ),
          )
      ),);
  }
}

//매니저의 커뮤니티 생성
class gradeManager extends StatefulWidget {
  const gradeManager({super.key});

  @override
  State<gradeManager> createState() => _gradeManagerState();
}
class _gradeManagerState extends State<gradeManager> {
  var communityName = TextEditingController();
  var communityPeriod = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: TextField(
                  controller: communityName,
                  decoration: InputDecoration(
                      labelText: 'Name if your community',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: TextField(
                  controller: communityPeriod,
                  decoration: InputDecoration(
                      labelText: 'Post exposure period(days)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),)
                  ),
                ),
              ),
              TextButton(child: Text('Create Community'),
                onPressed: (){
                  //community 만들고 메인페이지로 이동
                  //context.read<UserStore>().addCommunity(communityName.text, communityPeriod.text);
                },),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => MyApp()));
              }, child: Text('Sign In'))
            ],
          ),
        )
    );
  }
}