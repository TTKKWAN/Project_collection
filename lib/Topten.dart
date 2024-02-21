import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'util.dart';

class Topten extends StatefulWidget {
  Topten({Key? key, this.data, this.addData, this.removedata})
      : super(key: key);

  final data;
  final addData;
  final removedata;

  @override
  State<Topten> createState() => _ToptenState();
}

class _ToptenState extends State<Topten> {
  ////// 여기는 그냥 데이터 로드 부분
  var Topdata = [];

  Rankpr(a) {
    var f = a + 1;
    var rank;

    if (f == 1) {
      rank = 'st ';
    } else if (f == 2) {
      rank = 'nd ';
    } else if (f == 3) {
      rank = 'rd ';
    } else {
      rank = 'th ';
    }

    return (f.toString() + rank);
  }

  TopDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              // elevation: 10,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Column(
                children: [
                  Text('Ranking',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0,
                          color: Colors.black))
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var n = 1; n < widget.data.length; n++)
                    Text(
                      Rankpr(n - 1) + Topdata[n - 1]['title'], // user -> title
                      style: TextStyle(fontSize: 20),
                    ),
                ], // 여기 json 코드 바꾸면 title로 수정
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 218, 245, 245),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인'),
                )
              ],
            ));
    // }
  }

  @override
  void initState() {
    super.initState();
    Topdata = widget.data.toList();
    Topdata.sort((a, b) {
      final likeA = a['hearts'];
      final likeB = b['hearts'];

      if (likeA == null && likeB == null) return 0;
      if (likeA == null) return 1;
      if (likeB == null) return -1;

      return (likeB as int).compareTo(likeA as int);
    });
    // print(Topdata);
    // print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 244, 247, 247),
                  minimumSize: Size(120, 50)),
              onPressed: () => TopDialog(), // 여기가 다이얼로그 뜨는 곳
              child: Text('Top 10',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30.0,
                      color: Colors.black))),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: Topdata.length <= 10 ? Topdata.length : 10,
              itemBuilder: (BuildContext context, int index) {
                var f = index + 1;
                var rank;

                if (f == 1) {
                  rank = 'st';
                } else if (f == 2) {
                  rank = 'nd';
                } else if (f == 3) {
                  rank = 'rd';
                } else {
                  rank = 'th';
                }

                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$f', // 숫자
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  rank, // 순위 문자
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.width * 5 / 14,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 233, 245, 247),
                                border: Border.all(
                                    color: Color.fromARGB(255, 181, 234, 244),
                                    width: 1.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Toptenmenucomponent(
                                  data: Topdata[index],
                                  real: widget.data[index]),
                            ),
                          ],
                        )));
              }),
        )
      ],
    );
  }
}

class Toptenmenucomponent extends StatefulWidget {
  const Toptenmenucomponent({Key? key, this.data, this.real}) : super(key: key);

  final data;
  final real;

  @override
  State<Toptenmenucomponent> createState() => _ToptenmenucomponentState();
}

class _ToptenmenucomponentState extends State<Toptenmenucomponent> {
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
          widget.data['image'].runtimeType == String
              ? Image.network(
                  widget.data['image'],
                  width: MediaQuery.of(context).size.width *
                      3 /
                      10, // 여기 텍스트 부분 가로
                  height: MediaQuery.of(context).size.width * 3 / 10,
                )
              : Image.file(
                  widget.data['image'],
                  width: MediaQuery.of(context).size.width *
                      3 /
                      10, // 여기 텍스트 부분 가로
                  height: MediaQuery.of(context).size.width * 3 / 10,
                ),
          const SizedBox(width: 10),
          Container(
              width: MediaQuery.of(context).size.width * 1 / 2, // 여기
              child: Column(
                children: [
                  Text(
                    widget.data['title'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                ],
              )),
          const Spacer(),
        ],
      ),
    );
  }
}
