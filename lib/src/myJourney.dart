import 'package:danim/calendar_view.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/timetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String previousDiary = '';

  MyJourney(this.journey, this.dates, this.index, this.previousDiary);

  @override
  State<MyJourney> createState() =>
      _MyJourneyState(journey, dates, index, previousDiary);
}

//첫날, 끝날 기준으로 그 사이 날짜들 다 저장하는 리스트 생성하는 함수
List<DateTime> createDateList(List<DateTime> dates) {
  List<DateTime> dateList = [];

  for (int i = 0; i < dates[1].difference(dates[0]).inDays + 1; i++) {
    dateList.add(dates[0].add(Duration(days: i)));
  }

  return dateList;
}

class _MyJourneyState extends State<MyJourney> {
  List<CalendarEventData> journey = []; //calendarEventData 리스트 한 여행에 대한.
  List<DateTime> dates = []; // 첫날, 마지막날 있음
  List<String> diary = [];
  int index = -1; //몇번째인지 인덱스
  String previousDiary = '';
  late List<DateTime> dateList = createDateList(dates);

  TextEditingController courseReview =
      TextEditingController(); //코스 리뷰 저장되는 컨트롤러
  int rate = 4; //코스 별점, 4점 기준이라 기본 4점으로 저장함.

  _MyJourneyState(this.journey, this.dates, this.index, this.previousDiary);
/*
  List<TextEditingController> createTextController(dateList) {
    List<TextEditingController> textControllers = [];

    for (int i = 0; i < dateList.length; i++) {
      textControllers.add(TextEditingController(text: '이전에 저장한 일기...'));
    }
    return textControllers;
  }


 */
  TextEditingController textController = TextEditingController();

  initState() {
    super.initState();

    textController = TextEditingController(text: previousDiary);
  }

  dispose() {
    textController.dispose();
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
          child: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40)
            ]),
          ),
        ),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.

          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: Column(children: [
                                Text("이 코스 어떠셨나요?"),
                                Row(children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        print("1");
                                        rate = 1;
                                      },
                                      child: Text('1')),
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

                                      int traveledPlaceNum =
                                          readData.placeNumList[index] as int;

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
              child:
                  Image.asset(IconsPath.rate, fit: BoxFit.contain, height: 30)),

          TextButton(
              child: Image.asset(IconsPath.journey,
                  fit: BoxFit.contain, height: 30),
              onPressed: () async {
                //여기서 timetable 다시 띄우기

                for (int i = 0; i < journey.length; i++) {
                  print('journey_lat : ${journey[i].title}');
                }

                List<List<Place>> oldPreset = [
                  for (int i = 0;
                      i <
                          widget.dates[1].difference(widget.dates[0]).inDays +
                              1;
                      i++)
                    []
                ]; // 프리셋 초기화

                // List<DateTime> dateList = [];

                /*
                for (int i = 0;
                    i < widget.dates[1].difference(widget.dates[0]).inDays + 1;
                    i++) {
                  dateList.add(DateTime(widget.dates[0].year,
                      widget.dates[0].month, widget.dates[0].day + i));
                } // 날짜 리스트

                 */

                for (int i = 0; i < dateList.length; i++) {
                  for (int j = 0; j < journey.length; j++) {
                    if ((dateList[i].year == journey[j].date.year &&
                            dateList[i].month == journey[j].date.month &&
                            dateList[i].day == journey[j].date.day) &&
                        (journey[j].title != '이동') &&
                        (journey[j].title != '식사시간')) {
                      oldPreset[i].add(Place(
                          journey[j].title,
                          journey[j].latitude,
                          journey[j].longitude,
                          journey[j]
                              .endTime
                              .difference(journey[j].startTime)
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

                for (int i = 0; i < oldPreset.length; i++) {
                  for (int j = 0; j < oldPreset[i].length; j++) {
                    print('${i}째 날 ${j}째 코스 : ${oldPreset[i][j].name}');
                  }
                }

                //print('lati : ${oldPreset[0][0].latitude}');
                //print(oldPreset[0][0].longitude);

                List<List<int>> movingTimeList = [
                  for (int i = 0; i < oldPreset.length; i++) []
                ];

                movingTimeList = await createDrivingTimeList(oldPreset);

                print(oldPreset);
                print(movingTimeList);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Timetable(
                              preset: oldPreset,
                              transit: 0,
                              movingTimeList: movingTimeList,
                            )));
              }),
          TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                //첫화면까지 팝해버리는거임
              },
              child: Image.asset(IconsPath.house,
                  fit: BoxFit.contain, height: 30)),
        ],
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
            Container(
                child: Column(children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                      '${dateList[0]} - ${dateList[dateList.length - 1]}')),
              SizedBox(
                  width: 200,
                  height: 400,
                  child: TextFormField(
                    controller: textController,
                  ))
            ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    child: Text('저장'),
                    onPressed: () {
                      diary.add(textController.text);

                      fb_write_diary(readData.docCode, diary);

                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: SizedBox(
                                    width: 300,
                                    height: 150,
                                    child:
                                        Center(child: Text("일기가 저장되었습니다."))));
                          });
                      //여기서 DB로 넘기면 됨 !!!!!
                      //일기 출력 구현 했음.
                      //print(diaries);
                    }))
          ])),
    );
  }
}
