import 'dart:async';
import 'package:danim/src/place.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:danim/src/timetable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';

import 'package:danim/src/login.dart';
import 'package:danim/src/myPage.dart';

import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/user.dart';

import 'createMovingTimeList.dart';

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


      for (int i = 0; i < searchedUser.eventList.length; i++) {
        print('journey_lat : ${searchedUser.eventList[i].title}');
      }



      List<DateTime> dateList = [];


                      for (int i = 0;
                      i < searchedUser.eventList[searchedUser.eventList.length-1].date.difference(searchedUser.eventList[0].date).inDays + 1;
                      i++) {
                      dateList.add(DateTime(searchedUser.eventList[0].date.year,
                          searchedUser.eventList[0].date.month, searchedUser.eventList[0].date.day + i));
                      } // 날짜 리스트

      print(dateList);

    List<List<Place>> oldPreset = [
      for (int i = 0; i < dateList.length; i++)
        []
    ];


                      //이걸 못하는 거 같음.
      for (int i = 0; i < dateList.length; i++) {
        for (int j = 0; j < searchedUser.eventList.length; j++) {
          if ((dateList[i].year == searchedUser.eventList[j].date.year &&
              dateList[i].month ==
                  searchedUser.eventList[j].date.month &&
              dateList[i].day ==
                  searchedUser.eventList[j].date.day) &&
              (searchedUser.eventList[j].title != '이동') &&
              (searchedUser.eventList[j].title != '식사시간')) {
            oldPreset[i].add(Place(
                searchedUser.eventList[j].title,
                searchedUser.eventList[j].latitude,
                searchedUser.eventList[j].longitude,
                searchedUser.eventList[j]
                    .endTime
                    .difference(searchedUser.eventList[j].startTime)
                    .inMinutes,
                60,
                [0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0]));
          }
        }
      }

      //타임테이블 생성 잘 됐나 출력
      // 지금 여기서 안돼.. 왜?

      for (int i = 0; i < oldPreset.length; i++) {
        for (int j = 0; j < oldPreset[i].length; j++) {
          print(
              '${i}째 날 ${j}째 코스 : ${oldPreset[i][j].name}');
        }
      }

      //print('lati : ${oldPreset[0][0].latitude}');
      //print(oldPreset[0][0].longitude);

      List<List<int>> movingTimeList = [
        for (int i = 0; i < oldPreset.length; i++) []
      ];

      List<List<String>> movingStepsList = [
        for (int i = 0; i < oldPreset.length; i++) []
      ];

      movingTimeList =
      await createDrivingTimeList(oldPreset);
      startDay=dateList[0];
      endDay=dateList[dateList.length-1];
      print(oldPreset);
      print(movingTimeList);
      print("시작시간 ${searchedUser.eventList[0].startTime.hour}\n");
      print("끝시간 ${searchedUser.eventList[searchedUser.eventList.length-1].endTime.hour}\n");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Timetable(
                preset: oldPreset,
                transit: 0,
                movingTimeList: movingTimeList,
                startDayTime: searchedUser.eventList[0].startTime.hour,
                endDayTime: searchedUser.eventList[searchedUser.eventList.length-1].endTime.hour,
                movingStepsList: movingStepsList,
              )));



    } catch (e) {
      print('에러 $e');
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
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                        child:Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              child: Text("Warning!",
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                  ))),
                        )),
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
          child: Column(children: [
            Container(padding: EdgeInsets.fromLTRB(0, 250, 0, 0)),
            Center(child: SpinKitRing(color: Colors.grey)),
            SizedBox(height:15),
            Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text("타임 테이블을 생성하고 있습니다.",
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      )),
                )),
          ]),
        ));
  }
}
