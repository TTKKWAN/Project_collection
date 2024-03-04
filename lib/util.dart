import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:tttoy/text.dart';

List<String> lst = [
  'assets/ok.png',
  'assets/im2.jpg',
  'assets/im3.jpg',
  'assets/desk.jpg',
  'assets/land.jpg',
  'assets/rain.webp',
];

Widget makeImage(BoxFit option, photo) {
  return Container(
    child: Image.asset(photo, width: 100, height: 100, fit: option),
    padding: EdgeInsets.only(left: 2, right: 2, bottom: 1),
  );
}

Widget makeImagedetail(BoxFit option, photo) {
  return Container(
    child: Image.asset(photo, width: 300, height: 300, fit: option),
    padding: EdgeInsets.only(left: 2, right: 2, bottom: 1),
  );
}

class menuComponent extends StatefulWidget {
  const menuComponent({Key? key, this.data, this.index}) : super(key: key);

  final data;
  final index;

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
                    index: widget.index,
                    data: widget.data,
                    comment: comment,
                    addComment: addComment)));
      },
      child: Row(
        children: [
          (widget.data['photos'][0].contains("photo"))
              ? (widget.index == null
                  ? Text('photo')
                  : makeImage(BoxFit.fill, lst[widget.index]))
              : Image.file(File(widget.data['photos'][0]),
                  width: 100, height: 100, fit: BoxFit.fill
                  // width: MediaQuery.of(context).size.width *
                  //     3 /
                  //     10, // 여기 텍스트 부분 가로
                  // height: MediaQuery.of(context).size.width * 3 / 10,
                  ), // 일단 사진 삽입할 부분 체크
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
  detailPage({super.key, this.data, this.comment, this.addComment, this.index});
  final data;
  final comment;
  final addComment;
  final index;

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
          Text('GDSC OF KOREA '),
          SizedBox(
            width: 15,
          )
        ]),
        body: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            (widget.data['photos'][0].contains("photo"))
                ? (widget.index == null
                    ? Text('photo')
                    : makeImagedetail(BoxFit.fill, lst[widget.index]))
                : Image.file(File(widget.data['photos'][0]),
                    width: 200, height: 200, fit: BoxFit.fill),
            Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.data['hearts']++;
                      f++;
                    });
                  },
                  icon: (f % 2 == 0
                      ? Icon(Icons.favorite_border)
                      : Icon(Icons.favorite)),
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    widget.data['hearts'].toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(widget.data['content'], /////////// 여기가 본문
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NanumSquareRegular')),
                  ),
                ],
              )),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: [
                    TextFormField(
                        controller: commentInput,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xA1E7E4E4),
                          hintText: 'Add a comment',
                        )),
                    ElevatedButton(
                      onPressed: () {
                        if (commentInput.text.isNotEmpty) {
                          setState(() {
                            widget.addComment(
                                commentInput.text); // 여기에 댓글추가 함수 집어넣으면 될듯.
                          });
                        }
                      },
                      child: Text('Send'),
                    )
                  ],
                )),
            Container(
              height: 0.5,
              width: 500.0,
              color: Colors.black,
            ),
            Flexible(
              child: Container(
                  child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.comment.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(widget.comment[idx].toString()));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )),
            )
          ],
        ));
  }
}
      
      
      // CustomScrollView(slivers: <Widget>[
      //   SliverToBoxAdapter(
      //       child: (widget.data['photos'][0].contains("photo")
      //           ? Text('This is photo place')
      //           : Image.file(
      //               File(widget.data['photos'][0]),
      //               width: MediaQuery.of(context).size.width * 1.5 / 10,
      //             ))),
      //   SliverToBoxAdapter(
      //       child: Row(children: [
      //     Container(
      //         child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const SizedBox(width: 5),
      //         IconButton(
      //             onPressed: () {
      //               setState(() {
      //                 widget.data['hearts']++;
      //               });
      //             },
      //             icon: Icon(Icons.favorite)),
      //         Text(widget.data['hearts'].toString())
      //       ],
      //     )),
      //     Container(
      //         child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         const SizedBox(width: 5),
      //         Flexible(
      //           child: Text(widget.data['content'], /////////// 여기가 본문
      //               style: TextStyle(
      //                   color: Colors.black, fontFamily: 'NanumSquareRegular')),
      //         ),
      //       ],
      //     ))
      //   ])),
      //   SliverToBoxAdapter(
      //     child: Padding(
      //         padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      //         child: Column(
      //           children: [
      //             TextFormField(
      //                 controller: commentInput,
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor: Color(0xA1E7E4E4),
      //                   hintText: 'Add a comment',
      //                 )),
      //             ElevatedButton(
      //               onPressed: () {
      //                 if (commentInput.text.isNotEmpty) {
      //                   setState(() {
      //                     widget.addComment(
      //                         commentInput.text); // 여기에 댓글추가 함수 집어넣으면 될듯.
      //                   });
      //                 }
      //               },
      //               child: Text('Send'),
      //             )
      //           ],
      //         )),
      //   ),
        
      //   // SliverFixedExtentList(
      //   //   itemExtent: 30.0,
        //   delegate: SliverChildBuilderDelegate(
        //       (BuildContext context, int index) {

        //   },
        //       childCount:
        //           widget.comment.length == null ? 0 : widget.comment.length),
        // ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //       (context, index) => ListTile(
        //           leading: Icon(Icons.person),
        //           title: Text(widget.comment[index].toString())),
        //       childCount: widget.comment.length),
        // ),

        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (c, i) {
        //       return ListTile(
        //           leading: Icon(Icons.person),
        //           title: Text(widget.comment[i].toString()));
        //     },
        //     childCount: widget.comment.length,
        //   ),
        // )




// SliverToBoxAdapter(child: Text('This is photo place')),
          // widget.data['photos'][0].runtimeType == String
          // ? Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: Image.network(widget.data['photos']),
          //   )
          // ? Column(children: [
          //     Image.file(
          //       File(widget.data['photos'][0]),
          //       width: MediaQuery.of(context).size.width * 1.5 / 10,
          //     ),
          // widget.data['photo'].length > 1 ////////////// 하아
          //     ? Image.file(
          //         File(widget.data['photos'][1]),
          //         width: MediaQuery.of(context).size.width * 1.5 / 10,
          //       )
          //     : Text("y")
          // ])],


          // SliverToBoxAdapter(
          //   child: Row(
          //     children: [
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       IconButton(
          //         icon: f % 2 == 1
          //             ? Icon(Icons.favorite)
          //             : Icon(Icons.favorite_border_outlined),
          //         color: f % 2 == 0 ? Colors.red : Colors.red,
          //         onPressed: () {
          //           setState(() {
          //             if (f % 2 == 0) {
          //               widget.data['hearts']++;
          //             } else {
          //               widget.data['hearts']--;
          //             }
          //             f++;
          //           });
          //         },
          //       ),
          //       // icon: const Icon(Icons.favorite_border)),
          //       Text(widget.data['hearts'].toString()),
          //     ],
          //   ),
          // ),