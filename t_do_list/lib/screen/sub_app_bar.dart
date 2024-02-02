import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubAppBar extends StatelessWidget {
  const SubAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //앱바와 페이지의 구분을 주기 위해 BoxShadow로 그림자 만들어서 사용.
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // 뒤로 가는 버튼 구현
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back,
                  color: Colors.black87, size: 30), // 뒤로가기 아이콘 구현
            ),
            const Text(
              '서브 페이지 앱바',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
