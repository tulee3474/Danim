import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';

import 'package:danim/src/login.dart';
import 'package:danim/src/myPage.dart';

import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/user.dart';

class LoadingOtherCourse extends StatefulWidget {
  LoadingOtherCourse(String this.searchText, {super.key});
  String searchText;

  @override
  State<LoadingOtherCourse> createState() => _LoadingOtherCourseState();
}

class _LoadingOtherCourseState extends State<LoadingOtherCourse> {
  Future<void> eeee() async {
    //Future<User> fb_read_other_course(String docCodeNum)
    //docCodeNum - docCode/num 형태, num은 1, 2, 3, 4 - event뒤의 숫자와 동일
    //여기서 코스 코드 검색하면 됨 !!

    var read = ReadController();
    User searchedUser;

    try {
      searchedUser = await (read.fb_read_other_course(widget.searchText));
      print(searchedUser.eventList);
      //타임테이블 띄워

    } catch (e) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                content: SizedBox(
                    width: 250,
                    height: 100,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              child: Text("Warning!",
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              child: Text('에러코드' + widget.searchText,
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              child: Text('잘못된 코드입니다.',
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ],
                    )));
          });
    }
  }

  @override
  initState() {
    eeee();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
          ),
          actions: [
            //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
            //이곳에 한개 이상의 위젯들을 가진다.

            // TextButton(
            //     onPressed: () {
            //       Navigator.popUntil(context, (route) => route.isFirst);
            //       //첫화면까지 팝해버리는거임
            //     },
            //     child: Image.asset(IconsPath.house,
            //         fit: BoxFit.contain, height: 30)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: SpinKitRing(color: Colors.grey)),
            ]),
          ),
        ));
  }
}