import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';
import 'package:http/http.dart' as http;
import 'signin.dart';
import 'community.dart';

//회원가입 페이지
//nickname, email, password, userLevel을 입력받는다.
class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  var nicknameText = TextEditingController();
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  var userLevelText = TextEditingController();


  Future<void> signUp() async{
    Map<String, dynamic> body = {
      "nickname":"sebin",
      "email":"sebinemail",
      "password":"expw",
      "userLevel": "MEMBER"
    };

    var url = Uri.parse('https://server-irxa6nl5aa-uc.a.run.app/auth/signup');
    try{
      var response = await http.post(
          url,
          body: jsonEncode(body));
      if(response.statusCode == 200) {
        print('success');
      }
      else{
        print('fail');
      }
    } catch(e){
      print('error occured');
    }
  }

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

            //userLevel
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextField(
                controller: userLevelText,
                decoration: InputDecoration(
                    labelText: 'MEMBER or MANAGER',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),)
                ),
              ),
            ),

            ElevatedButton(child: Text('Sign Up'),
                onPressed: (){



                  //context.read<UserStore>().addUser(nicknameText.text, emailText.text, passwordText.text, userLevelText.text);
                  //context.watch<UserStore>().mypageid = context.watch<UserStore>().users.length;

                  Navigator.push(context, MaterialPageRoute(builder: (c) => SignIn()));
                })
          ],
        ),
      ),
    );
  }
}