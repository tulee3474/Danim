import 'package:danim/calendar_view.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/feedback_point.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/myPage.dart';

import 'createMovingTimeList.dart';

class MyJourney extends StatefulWidget {
  List<CalendarEventData> journey = [];
  List<DateTime> dates = [];
  int index = -1;

  MyJourney(this.journey, this.dates, this.index);

  @override
  State<MyJourney> createState() => _MyJourneyState(journey, dates, index);
}

class _MyJourneyState extends State<MyJourney> {
  List<CalendarEventData> journey = [];
  List<DateTime> dates = [];
  List<String> diaries = [];
  int index = -1;

  TextEditingController courseReview =
      TextEditingController(); //코스 리뷰 저장되는 컨트롤러
  int rate = 4; //코스 별점, 4점 기준이라 기본 4점으로 저장함.

  _MyJourneyState(this.journey, this.dates, this.index);

  List<TextEditingController> createTextController(dates) {
    List<TextEditingController> textControllers = [];

    for (int i = 0; i < dates.length; i++) {
      textControllers.add(TextEditingController());
    }
    return textControllers;
  }

  late List<TextEditingController> textControllers =
      createTextController(dates);

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
              child:
                  Image.asset(IconsPath.back, fit: BoxFit.contain, height: 20)),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: SizedBox(
                              height: 350.0,
                              width: 300,
                              child: Column(children: [
                                Text("이 코스 어떠셨나요?"),
                                Row(children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        print("1");
                                        rate = 1;
                                      },
                                      child: Text('2')),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("2");
                                        rate = 2;
                                      },
                                      child: Text('2')),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("3");
                                        rate = 3;
                                      },
                                      child: Text('3')),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("4");
                                        rate = 4;
                                      },
                                      child: Text('4')),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("5");
                                        rate = 5;
                                      },
                                      child: Text('5'))
                                ]),
                                TextField(
                                  controller: courseReview,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '리뷰'),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      // 여기서 DB 연결 !!!
                                      ReadController read = ReadController();
                                      List<List<int>> selectList =
                                          await read.fb_read_user_selectList(
                                              readData.docCode, index);

                                      List<String> traveledPlaceList =
                                          []; //여행다녔던 관광지들 1차원 배열
                                      int placeNum = 0;
                                      for (int p = 0; p < index; p++) {
                                        placeNum +=
                                            readData.placeNumList[p] as int;
                                      }

                                      int traveledPlaceNum = readData
                                          .placeNumList[placeNum] as int;

                                      for (int p = placeNum;
                                          p < placeNum + traveledPlaceNum;
                                          p++) {
                                        traveledPlaceList
                                            .add(readData.traveledPlaceList[p]);
                                      }

                                      feedback(
                                          readData.travelList[index],
                                          traveledPlaceList,
                                          selectList,
                                          rate,
                                          courseReview.text);

                                      //print('${rate}'); //별점
                                      //print('${courseReview.text}'); //리뷰
                                      //print('${journey}');
                                    },
                                    child: Text("리뷰 저장"))
                              ])));
                    });
              },
              child: Icon(Icons.rate_review)),
          TextButton(
              child: Icon(Icons.trip_origin),
              onPressed: () async {
                //여기서 timetable 다시 띄우기

                List<List<Place>> oldPreset = [
                  for(int i=0; i< widget.dates[1].difference(widget.dates[0]).inDays +1; i++)
                    []
                ];// 프리셋 초기화

                List<DateTime> dateList = [];

                for(int i=0; i<widget.dates[1].difference(widget.dates[0]).inDays +1; i++ ){

                  dateList.add(DateTime(widget.dates[0].year, widget.dates[0].month, widget.dates[0].day + i ));

                }// 날짜 리스트

                for(int i=0; i<dateList.length; i++){

                  for(int j=0; j<journey.length; j++){
                    if(dates[i].year == journey[j].date.year && dates[i].month == journey[j].date.month && dates[i].day == journey[j].date.day){

                      oldPreset[i].add(
                        Place(
                          journey[j].title,
                          35.5,
                          127,
                          journey[j].endTime.difference(journey[j].startTime).inMinutes,
                          60,
                            [0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0]
                        )
                      );

                    }
                  }

                }

                //타임테이블 생성



                  List<List<int>> movingTimeList = [
                    for(int i=0; i<oldPreset.length; i++)
                      []
                  ];

                  movingTimeList = await createDrivingTimeList(oldPreset);


                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Timetable(preset: oldPreset, transit: 0, movingTimeList: movingTimeList,)));










              })
        ]),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
                alignment: FractionalOffset.centerLeft,
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text("${journey[0].date.year}" +
                    '.' +
                    "${journey[0].date.month}" +
                    '.' "${journey[0].date.day}" +
                    ' - ' +
                    "${journey[journey.length - 1].date.year}" +
                    '.' +
                    "${journey[journey.length - 1].date.month}" +
                    '.' +
                    "${journey[journey.length - 1].date.day}")),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            for (int i = 0; i < dates.length; i++)
              Container(
                  child: Column(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text('${dates[i]}')),
                SizedBox(
                    width: 200,
                    height: 400,
                    child: TextField(
                      controller: textControllers[i],
                    ))
              ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    child: Text('저장'),
                    onPressed: () {
                      for (int i = 0; i < dates.length; i++) {
                        diaries.add(textControllers[i].text);
                      }
                      fb_write_diary(readData.docCode, diaries);
                      //여기서 DB로 넘기면 됨 !!!!!
                      //일기 출력은 구현 안된거 같음. db에서 일기 가져오는 곳이 없음
                      //print(diaries);
                    }))
          ])),
    );
  }
}
