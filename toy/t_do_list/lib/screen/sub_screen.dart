import 'sub_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubScreen extends StatelessWidget {
  const SubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), // 앱바 높이 조절
          child: SubAppBar(),
        ),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: Text('서브 페이지 입니다.'),
        ),
      ),
    );
  }
}
