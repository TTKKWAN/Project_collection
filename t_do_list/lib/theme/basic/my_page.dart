import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util.dart';
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 280,
            margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Text(
              '  Manager [KU apt]',
              style: TextStyle(fontSize: 30),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 239, 240, 239),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.1,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {},
                iconSize: 40,
                icon: const Icon(Icons.manage_accounts_rounded),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 248, 248, 244)),
                )),
            Container(
              width: 160,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(
                ' Nickname',
                style: TextStyle(fontSize: 30),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 240, 239),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
            ),
          ],
        ),
        Flexible(
            child: Container(
          height: 1.0,
          // width: 510.0,
          color: const Color.fromARGB(255, 19, 17, 17),
        )),
        Text(
          'My activity',
          style: TextStyle(fontSize: 45),
        ),
        Flexible(
            child: Container(
          height: 1.0,
          // width: 510.0,
          color: const Color.fromARGB(255, 19, 17, 17),
        )),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 360,
          child: ListView.separated(
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return postComponent(context, index);
              },
              separatorBuilder: (BuildContext ctx, int idx) {
                return Divider();
              }),
        )
      ],
    );
  }
}

List<String> lst = [
  'camera.jpg',
  'balcony.jpg',
  'rain.webp',
  'land.jpg',
];

Widget postComponent(BuildContext context, int index) {
  // 게시물의 구성요소
  return Row(children: [
    const SizedBox(width: 10),
    const Icon(Icons.photo, size: 80),
    const SizedBox(width: 10),
    Container(
      // height: 70,
      child: Text(
        'Content Title ${index + 1}',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const SizedBox(
      width: 110,
    ),
    const Icon(Icons.view_list_rounded, size: 80),
  ]);
}
