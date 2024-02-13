import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'util.dart';

List<String> lst = [
  'camera.jpg',
  'balcony.jpg',
  'rain.webp',
  'desk.jpg',
];

Widget viewToDoDialog(BuildContext context, List content) {
  return AlertDialog(
    title: Text(content[0]),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(content[1])],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Close"),
      )
    ],
  );
}

Widget menuComponent(BuildContext context, content, int index) {
  // 게시물의 구성요소
  // List content = jsonDecode(content);

  return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          onPressed: () {
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return viewToDoDialog(context, content);
            //     });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          child: Column(
            children: [
              Container(
                  //child: Text('Location'),
                  height: MediaQuery.of(context).size.width * 3 / 10 + 10,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 232, 249, 233),
                    border: Border.all(
                        color: Color.fromARGB(255, 181, 244, 187), width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      // Image.asset(
                      //     'assets/tramp.jpg'), // padding 조절 시 크기 알아서 조절 됨.
                      Image.asset(
                        lst[index % 4],
                        width: MediaQuery.of(context).size.width * 3 / 10, // 여기
                        height: MediaQuery.of(context).size.width * 3 / 10,
                      ),
                      const SizedBox(width: 10),
                      Container(
                          width:
                              MediaQuery.of(context).size.width * 1 / 2, // 여기
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                content[0], ///////// 여기가 제목
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                  child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                strutStyle: StrutStyle(fontSize: 16.0),
                                text: TextSpan(
                                    text: content[1], /////////// 여기가 본문
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 1.4,
                                        fontSize: 16.0,
                                        fontFamily: 'NanumSquareRegular')),
                              )),
                            ],
                          )),
                      const Spacer(),
                      deleteButton(),
                    ],
                  )),
            ],
          )));
}

class deleteButton extends StatelessWidget {
  const deleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ));
  }
}
