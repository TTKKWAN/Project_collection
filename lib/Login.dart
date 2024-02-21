
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  var loginemail = TextEditingController();
  var loginpw = TextEditingController();
  bool membercheck = false;
  bool communityCheck = true;

  getCommunityCheck() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      if (result2 == false) {
        communityCheck = false;
      };
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,
        () => context.read<UserStore>().getData_users()
    );
    Future.delayed(Duration.zero,
        () => context.read<UserStore>().getData_communities()
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => UserStore(),
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  //이메일
                  child: TextField(
                    controller: loginemail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),)
                    ),
                  ),),
                //비밀번호
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    controller: loginpw,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),)
                    ),
                  ),),
                //로그인 버튼, 회원가입으로 이동 텍스트, sizedbox는 그냥 정렬을 위한 것
                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: (){
                      context.read<UserStore>().getData_users();
                      context.read<UserStore>().getData_communities();
                      membercheck = context.read<UserStore>().isMember(loginemail, loginpw);
                    }, child: Text('Submit')),
                    ElevatedButton(child: Text('Sign In'), onPressed: () {
                      //getCommunityCheck();
                      if (communityCheck) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (c) => MyApp()));
                      } else {
                        if (context
                            .read<UserStore>()
                            .users[context
                            .read<UserStore>()
                            .users
                            .length]['userLevel'] == 'MEMBER') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => gradeMember()));
                        } else if (context
                            .read<UserStore>()
                            .users[context
                            .read<UserStore>()
                            .users
                            .length]['userLevel'] == 'MANAGER') {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (c) => gradeManager()));
                        }
                      }
                    }),
                    GestureDetector(child: Text('Sign up'),
                      onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => SignUp()));
                      },),
                  ],
                ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//회원가입 페이지
class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  var nicknameText = TextEditingController();
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  var pwCheckText = TextEditingController();
  var userLevelText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            //nickname
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextField(
                controller: nicknameText,
                decoration: InputDecoration(
                    labelText: 'Nick Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),),
            //email
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                controller: emailText,
                decoration: InputDecoration(
                  
                    labelText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),),
            //pw
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                controller: passwordText,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),),
            //pw check
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextField(
                controller: pwCheckText,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Please input your password again',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),),
            //userLevel
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                controller: userLevelText,
                decoration: InputDecoration(
                    labelText: 'MEMBER or MANAGER',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),),
            ElevatedButton(child: Text('Sign Up'),
                onPressed: (){
              if (passwordText == pwCheckText){
                context.read<UserStore>().addUser(nicknameText.text, emailText.text, passwordText.text, userLevelText.text);
                context.watch<UserStore>().mypageid = context.watch<UserStore>().users.length;
              }
              Navigator.push(context, MaterialPageRoute(builder: (c) => SignIn()));
                })
          ],
        ),
      ),
    );
  }
}

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
//state 보관함
class UserStore extends ChangeNotifier {
  var communities = [];
  var users = [];
  var mypageid;
  var mygrade;

  getData_users() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    users = result2;
    notifyListeners();
  }

  getData_communities() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    communities = result2;
    notifyListeners();
  }

  isMember(id, pw){
    // 맞으면 메인페이지로 이동, 틀리면 오류메세지
    bool check = false;
    bool idcheck = false;
    bool pwcheck = false;
    for(var user in users){
      idcheck = user['email'].contains(id);
      pwcheck = user['password'].contains(pw);
      if(idcheck == true && pwcheck == true){
        mypageid = user['userid'];
        check = true;
      }
    }
    notifyListeners();
    return check;
  }

  //회원가입 시 닉네임, 이메일, 비밀번호 저장하는 함수
  addUser(name, email, pw, level){
    var userData = {
      'userid' : users.length,
      'nickname' : name,
      'email' : email,
      'password' : pw,
      'userLevel' : level,
    };
    users.add(userData);
    notifyListeners();
  }
  //커뮤니티 추가
  addCommunity(name, date){
    //커뮤니티 이름과 게시물 지속 날짜 저장
    var commutityData = {
      'communityName' : name,
      'postsExposurePeriod' : date,
    };
    communities.add(commutityData);

    notifyListeners();
  }

  //커뮤니티 검색
  searchData(a){
    //커뮤니티 검색에 들어간 단어들 데이터베이스로 보내는 함수
    var result = false;
    for (var com in communities){
      if(com['communityName'] == a){
        result = com['communityName'];
        users[mypageid]['community'] = com['communityName'];
      }
    }
    notifyListeners();
    return result;
  }
}