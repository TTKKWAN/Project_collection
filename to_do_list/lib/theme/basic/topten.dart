import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util.dart';

class ToptenList extends StatefulWidget {
  const ToptenList({Key? key}) : super(key: key);

  @override
  MenuListState createState() => MenuListState();
}

class MenuListState extends State<ToptenList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> listComponent = [];
  Future<void> _loadData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      listComponent = prefs.getStringList("listComponent") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget best() {
    return Container(
      margin: EdgeInsets.fromLTRB(100, 10, 100, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.stars,
            size: 30,
            color: Color.fromARGB(255, 153, 11, 189),
          ),
          const Text(
            'Top 10 ',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 211, 209, 227),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget deleteButton(int index, Function() onPressed) {
      return IconButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(const CircleBorder()),
            iconSize: MaterialStateProperty.all(25),
            alignment: Alignment.center),
        padding: const EdgeInsets.all(0),
        icon: const Icon(Icons.delete, color: Colors.grey),
      );
    }

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 리스트의 순서 조절 가능.
            best(),
            listComponent.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Text("No schedule",
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  )
                : ListView.builder(
                    // listview가있네
                    shrinkWrap: true,
                    itemCount: listComponent
                        .length, // 일단 100으로 해놓고 수정해야함 -> 대규모 업데이트가 필요할 때 ㅇㅇ
                    itemBuilder: (BuildContext context, int index) {
                      return menuComponent(
                          context,
                          listComponent[index],
                          deleteButton(index, () async {
                            final SharedPreferences prefs = await _prefs;
                            setState(() {
                              listComponent.removeAt(index);
                              prefs.setStringList(
                                  "listComponent", listComponent);
                            });
                          }));
                    }),
          ],
        ));
  }
}

Widget menuComponent(BuildContext context, content, Widget deleteButton) {
  List listContent = jsonDecode(content);

  return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return viewToDoDialog(context, listContent);
                });
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
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 196, 170, 238),
                    border: Border.all(
                        color: Color.fromARGB(255, 188, 141, 214), width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                          'assets/rain.webp'), // padding 조절 시 크기 알아서 조절 됨.
                      const SizedBox(width: 10),
                      Container(
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listContent[0],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                  child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                strutStyle: StrutStyle(fontSize: 16.0),
                                text: TextSpan(
                                    text: listContent[1],
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 1.4,
                                        fontSize: 16.0,
                                        fontFamily: 'NanumSquareRegular')),
                              )),
                            ],
                          )),
                      const Spacer(),
                      deleteButton
                    ],
                  )),
            ],
          )));
}
