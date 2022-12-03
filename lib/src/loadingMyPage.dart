import 'dart:async';

import 'package:danim/src/fixInfo.dart';
import 'package:danim/src/preset.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:danim/src/courseDetail.dart';

import 'dart:ui';
import 'package:danim/src/login.dart';
import 'package:danim/src/myPage.dart';

import 'package:danim/route_ai.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';

import 'accomodationInfo.dart';
import 'date_selectlist.dart';

class LoadingMyPage extends StatefulWidget {
  LoadingMyPage({super.key});

  int transit = 0;

  @override
  State<LoadingMyPage> createState() => _LoadingMyPageState();
}

class _LoadingMyPageState extends State<LoadingMyPage> {
  Future<void> wwww() async {
    //임시 텍스트
    if (token == '') {
      await readUserData("docCodeTest123");
    } else {
      await readUserData(token as String);
    }
    Timer(Duration(seconds: 0), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyPage()));
    });
  }

  @override
  initState() {
    wwww();
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
          title: InkWell(
              // onTap: () {
              //   Navigator.popUntil(context, (route) => route.isFirst);
              // },

              ),
          actions: [
            //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
            //이곳에 한개 이상의 위젯들을 가진다.

            TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  //첫화면까지 팝해버리는거임
                },
                child: Image.asset(IconsPath.house,
                    fit: BoxFit.contain, height: 30)),
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
