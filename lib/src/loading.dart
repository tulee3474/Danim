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

class Loading extends StatefulWidget {
  Loading(this.transit, {super.key});

  int transit = 0;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<List<List<List<Place>>>> loadPath(
      city, house, selectList, timeLimitArray, numPreset, nDay) async {
    var ai = RouteAI(); //RouteAI 클래스 생성

    List<List<List<Place>>> read_data;

    var stopwatch = Stopwatch();
    stopwatch.start();

    await ai.data_loading(city as String);
    try {
      read_data = (await ai.route_search(
              city,
              house,
              selectList,
              fixTourSpotList,
              fixDateList,
              timeLimitArray,
              nDay,
              widget.transit))
          .cast<List<List<Place>>>();
      print(read_data.length);
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
    } catch (e) {
      print(e);
      print('AI 실행 중, 에러 발생');
      print(house);
      print(selectList);
      print(fixTourSpotList);
      print(fixDateList);
      print(timeLimitArray);
      print(nDay);
      print(widget.transit);
      print('---------------------------------------------------------');

      read_data = [];
      return read_data;
    }
  }

  qqqq() async {
    bool houseCheck = false;
    if (accomodation != '') {
      houseCheck = true;
    }

    print(houseCheck);
    //임시 숙소
    Place? house = Place(
        accomodation,
        accomodation_lati,
        accomodation_long,
        10,
        1,
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0]);

    //selectList
    List selectList = selectedList;

    //도시
    String city = "제주도";

    if (!houseCheck) {
      house = null;
    }

    List<List<List<Place>>> path_ex = await loadPath(
        city,
        house,
        selectList,
        [dayStartingTime.hour, dayEndingTime.hour],
        5,
        endDay.difference(startDay).inDays + 1);
    Timer(Duration(seconds: 0), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Preset(path_ex, widget.transit)));
    });
  }

  @override
  initState() {
    //super.initState();
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
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            Container(padding: EdgeInsets.fromLTRB(0, 250, 0, 0)),
            Center(child: SpinKitRing(color: Colors.grey)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text('맞춤 관광코스 탐색중..',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Center(
                child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text("최대 1분까지 소요될 수 있습니다",
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  )),
            )),
          ]),
        ));
  }
}
