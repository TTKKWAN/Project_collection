import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 160,
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Text(
            'Nickname',
            style: TextStyle(fontSize: 30),
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 177, 243, 209),
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
    );
  }
}
