import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:tttoy/text.dart';

List<String> lst = [
  'camera.jpg',
  'balcony.jpg',
  'rain.webp',
  'desk.jpg',
];

class menuComponent extends StatefulWidget {
  const menuComponent({Key? key, this.data}) : super(key: key);

  final data;

  @override
  State<menuComponent> createState() => _menuComponentState();
}

class _menuComponentState extends State<menuComponent> {
  var comment = [];
  addComment(a) {
    setState(() {
      comment.add(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => detailPage(
                    data: widget.data,
                    comment: comment,
                    addComment: addComment)));
      },
      child: Row(
        children: [
          // widget.data['photos'].runtimeType == String
          //     ? Image.network(
          //         widget.data['photos'],
          //         width: MediaQuery.of(context).size.width *
          //             3 /
          //             10, // 여기 텍스트 부분 가로
          //         height: MediaQuery.of(context).size.width * 3 / 10,
          //       )
          //     : Image.file(
          //         widget.data['photos'],
          //         width: MediaQuery.of(context).size.width *
          //             3 /
          //             10, // 여기 텍스트 부분 가로
          //         height: MediaQuery.of(context).size.width * 3 / 10,
          //       ),

          const SizedBox(width: 10),
          Container(
              width: MediaQuery.of(context).size.width * 1 / 2, // 여기
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['title'], ///////// 여기가 제목
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(width: 10),
                  Container(
                      child: Row(children: [
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: Color.fromARGB(255, 242, 116, 107),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.data['hearts'].toString())
                  ])),
                  Flexible(
                      child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    text: TextSpan(
                        text: widget.data['content'], /////////// 여기가 본문
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NanumSquareRegular')),
                  )),
                  // Text(widget.data['content'])
                ],
              )),
          const Spacer(),
        ],
      ),
    );
  }
}

class detailPage extends StatefulWidget {
  detailPage({super.key, this.data, this.comment, this.addComment});
  final data;
  final comment;
  final addComment;

  @override
  State<detailPage> createState() => _detailPageState();
}

class _detailPageState extends State<detailPage> {
  var commentInput = TextEditingController();
  var f = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data['title'].toString()), actions: [
        Icon(Icons.location_on_outlined),
        Text('location'),
        SizedBox(
          width: 15,
        )
      ]),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: widget.data['photos'].runtimeType == String
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.network(widget.data['photos']),
                  )
                : Image.file(widget.data['photos']),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  icon: f % 2 == 1
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border_outlined),
                  color: f % 2 == 0 ? Colors.red : Colors.red,
                  onPressed: () {
                    setState(() {
                      if (f % 2 == 0) {
                        widget.data['hearts']++;
                      } else {
                        widget.data['hearts']--;
                      }
                      f++;
                    });
                  },
                ),
                // icon: const Icon(Icons.favorite_border)),
                Text(widget.data['hearts'].toString()),
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  child: Row(
            children: [
              const SizedBox(width: 5),
              Text(widget.data['content'], /////////// 여기가 본문
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'NanumSquareRegular')),
            ],
          ))),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: TextFormField(
                  controller: commentInput,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xA1E7E4E4),
                    hintText: 'Add a comment',
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              child: Text('Send'),
              onPressed: () {
                if (commentInput.text.isNotEmpty) {
                  setState(() {
                    widget.addComment(commentInput.text);
                  });
                }
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (c, i) {
                return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(widget.comment[i].toString()));
              },
              childCount: widget.comment.length,
            ),
          )
        ],
      ),
    );
  }
}
