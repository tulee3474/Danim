import 'dart:async';

import 'package:danim/src/preset.dart';
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

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<List<List<List<Place>>>> loadPath(city, house, selectList,
      fixedPlaceList, fixedDayList, timeLimitArray, numPreset, nDay) async {
    var ai = RouteAI(); //RouteAI 클래스 생성

    List<List<List<Place>>> read_data;

    var stopwatch = Stopwatch();
    stopwatch.start();

    await ai.data_loading(city as String);

    read_data = (await ai.route_search(city, house, fixedPlaceList,
            fixedDayList, selectList, timeLimitArray, numPreset, nDay))
        .cast<List<List<Place>>>();

    for (int i = 0; i < read_data.length; i++) {
      print("코스");
      for (int j = 0; j < read_data[i].length; j++) {
        print("날짜 : " + (j + 1).toString());
        for (int k = 0; k < read_data[i][j].length; k++) {
          print(read_data[i][j][k].name);
        }
      }
      print("---------------------------");
    }
    print("AI 돌리는데 걸리는 시간");
    print(stopwatch.elapsed);
    stopwatch.stop();

    return read_data;
  }

  qqqq() async {
    bool houseCheck = true;
    //임시 숙소
    Place? house = Place(
        "제주신라호텔",
        33.3615656,
        126.5290656,
        0,
        0,
        [0, 1, 0, 0, 0, 0, 0],
        [0, 1, 0, 1],
        [0, 1, 0, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 1, 0, 1],
        [0, 1, 0, 0]);
    //임시 selectList
    List selectList = [
      [0, 1, 0, 0, 0, 0, 0],
      [0, 1, 0, 1],
      [0, 1, 0, 0, 1, 0],
      [0, 1, 0, 1, 0, 1, 1, 0, 1],
      [0, 1, 0, 0]
    ];
    //임시 도시
    String city = "제주도";

    if (!houseCheck) {
      house = null;
    }

    List<List<List<Place>>> path_ex =
        await loadPath(city, house, selectList, [], [], [9, 18], 5, 3);
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Preset(path_ex)));
    });
  }

  @override
  initState() {
    qqqq();
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
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset(IconsPath.back,
                    fit: BoxFit.contain, height: 20))
          ]),
        ),
        body: Center(child: SpinKitRing(color: Colors.grey)));
  }
}
