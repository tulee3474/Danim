import 'package:danim/calendar_view.dart';
import 'package:danim/main.dart';
import 'package:danim/src/community.dart';
import 'package:danim/src/loadingMyPage.dart';
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
import 'login.dart';

class MyJourney extends StatefulWidget {
  List<CalendarEventData> journey = [];
  List<DateTime> dates = [];
  int index = -1;
  String previousDiary = '';
  String traveledCity = '';
  //임시로 그냥 넣음
  bool feedback = false;

  MyJourney(this.journey, this.dates, this.index, this.previousDiary,
      this.traveledCity);

  @override
  State<MyJourney> createState() =>
      _MyJourneyState(journey, dates, index, previousDiary, traveledCity);
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
  int index = -1; //몇번째인지 인덱스
  String previousDiary = '';
  String traveledCity = '';
  late List<DateTime> dateList = createDateList(dates);

  TextEditingController shareController = TextEditingController();

  TextEditingController courseReview =
      TextEditingController(); //코스 리뷰 저장되는 컨트롤러
  int rate = 4; //코스 별점, 4점 기준이라 기본 4점으로 저장함.

  _MyJourneyState(this.journey, this.dates, this.index, this.previousDiary,
      this.traveledCity);
/*
  List<TextEditingController> createTextController(dateList) {
    List<TextEditingController> textControllers = [];

    for (int i = 0; i < dateList.length; i++) {
      textControllers.add(TextEditingController(text: '이전에 저장한 일기...'));
    }
    return textControllers;
  }


 */
  static Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    }
    if (states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    } else
      return Colors.white;
  }

  List<MaterialStateProperty<Color>> rateButtonColorList = [
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor)
  ];

  void switchRateButtonColor(int index, int type) {
    if (type == 1) {
      setState(() {
        rateButtonColorList[index] = MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        rateButtonColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  TextEditingController textController = TextEditingController();

  initState() {
    super.initState();
    if (previousDiary == 'null') {
      textController = TextEditingController(text: '');
    } else {
      textController = TextEditingController(text: previousDiary);
    }
    shareController = TextEditingController();
  }

  dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPage()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: InkWell(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Image.asset(
                IconsPath.logo,
                fit: BoxFit.contain,
                height: 40,
              ),
            ),
          ),
          actions: [
            //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
            //이곳에 한개 이상의 위젯들을 가진다.
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  shareController.text = "${token}/${index + 1}";
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: SizedBox(
                              width: 300,
                              height: 180,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("공유 ID",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'Neo',
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: shareController,
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )));
                    },
                  );
                }),
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(children: [
                Text('${traveledCity}' + '여행',
                    style: TextStyle(
                      color: Color(0xff14BC57), //수정 색 변경
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Neo',
                    )),
                SizedBox(height: 5),
                Text(
                    "${journey[0].date.year}" +
                        '.' +
                        "${journey[0].date.month}" +
                        '.' "${journey[0].date.day}" +
                        ' - ' +
                        "${journey[journey.length - 1].date.month}" +
                        '.' +
                        "${journey[journey.length - 1].date.day}",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontFamily: 'Neo',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 30),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 245, 250, 253),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(3, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Text('여행 일기를 작성해보세요!',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontFamily: 'Neo',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 20),
                      TextField(
                        controller: textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffF4F4F4),
                          labelText: '내용을 입력해주세요',
                          labelStyle: TextStyle(fontFamily: "Neo"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                          width: double.infinity,
                          height: 40,
                          //padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                          child: ElevatedButton(
                              child: Text(
                                '일기 저장',
                                style: TextStyle(
                                  fontFamily: 'Neo',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 102, 202, 252),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: Color.fromARGB(255, 102, 202, 252),
                                    width: 2),
                              ),
                              onPressed: () {
                                if (textController.text == '') {
                                  diaries[widget.index] = "null";
                                  fb_write_diary(readData.docCode, diaries);
                                } else {
                                  diaries[widget.index] = textController.text;
                                  fb_write_diary(readData.docCode, diaries);
                                }

                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: SizedBox(
                                              width: 300,
                                              height: 150,
                                              child: Center(
                                                  child:
                                                      Text("일기가 저장되었습니다."))));
                                    });
                                //여기서 DB로 넘기면 됨 !!!!!
                                //일기 출력 구현 했음.
                                //print(diaries);
                              })),
                    ])),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                          onPressed: () async {
                            //여기서 timetable 다시 띄우기

                            for (int i = 0; i < journey.length; i++) {
                              print('journey_lat : ${journey[i].title}');
                            }

                            List<List<Place>> oldPreset = [
                              for (int i = 0;
                                  i <
                                      widget.dates[1]
                                              .difference(widget.dates[0])
                                              .inDays +
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
                                        dateList[i].month ==
                                            journey[j].date.month &&
                                        dateList[i].day ==
                                            journey[j].date.day) &&
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


                            print(oldPreset);
                            print(movingTimeList);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Timetable(
                                          preset: oldPreset,
                                          transit: 0,
                                          movingTimeList: movingTimeList,
                                      startDayTime: journey[0].startTime.hour,
                                      endDayTime: journey[journey.length-1].endTime.hour,
                                      movingStepsList: movingStepsList,
                                        )));
                          },
                          child: Text("여행 코스 확인",
                              style: TextStyle(
                                fontFamily: "Neo",
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                          onPressed: () {
                            if (widget.feedback) {
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Container(
                                                      child: Text(
                                                          "이미 리뷰를 남기셨습니다.",
                                                          style: TextStyle(
                                                            fontFamily: "Neo",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))),
                                                ),
                                              ],
                                            )));
                                  });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  //AlertDialog는 StateLess라서 setState가 안먹음. 따라서 StatefulBuilder로 감싸줌.
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                          content: SizedBox(
                                              height: 350.0,
                                              width: 350.0,
                                              child: Column(children: [
                                                SizedBox(height: 20),
                                                Text("이 코스 어떠셨나요?",
                                                    style: TextStyle(
                                                      fontFamily: "Neo",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    )),
                                                SizedBox(height: 20),
                                                Text("별점을 매겨주세요!",
                                                    style: TextStyle(
                                                      fontFamily: "Neo",
                                                      //fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    )),
                                                SizedBox(height: 10),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 40,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    rateButtonColorList[
                                                                        1]),
                                                            onPressed: () {
                                                              print("1");
                                                              rate = 1;
                                                              //버튼 색 변환
                                                              setState(() {
                                                                switchRateButtonColor(
                                                                    1, 1);
                                                                for (int b = 0;
                                                                    b < 6;
                                                                    b++) {
                                                                  if (b != 1) {
                                                                    switchRateButtonColor(
                                                                        b, 0);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              '1',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    rateButtonColorList[
                                                                        2]),
                                                            onPressed: () {
                                                              print("2");
                                                              rate = 2;
                                                              //버튼 색 변환
                                                              setState(() {
                                                                switchRateButtonColor(
                                                                    2, 1);
                                                                for (int b = 0;
                                                                    b < 6;
                                                                    b++) {
                                                                  if (b != 2) {
                                                                    switchRateButtonColor(
                                                                        b, 0);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              '2',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    rateButtonColorList[
                                                                        3]),
                                                            onPressed: () {
                                                              print("3");
                                                              rate = 3;
                                                              //버튼 색 변환
                                                              setState(() {
                                                                switchRateButtonColor(
                                                                    3, 1);
                                                                for (int b = 0;
                                                                    b < 6;
                                                                    b++) {
                                                                  if (b != 3) {
                                                                    switchRateButtonColor(
                                                                        b, 0);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              '3',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    rateButtonColorList[
                                                                        4]),
                                                            onPressed: () {
                                                              print("4");
                                                              rate = 4;
                                                              //버튼 색 변환
                                                              setState(() {
                                                                switchRateButtonColor(
                                                                    4, 1);
                                                                for (int b = 0;
                                                                    b < 6;
                                                                    b++) {
                                                                  if (b != 4) {
                                                                    switchRateButtonColor(
                                                                        b, 0);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              '4',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    rateButtonColorList[
                                                                        5]),
                                                            onPressed: () {
                                                              print("5");
                                                              rate = 5;
                                                              //버튼 색 변환
                                                              setState(() {
                                                                switchRateButtonColor(
                                                                    5, 1);
                                                                for (int b = 0;
                                                                    b < 6;
                                                                    b++) {
                                                                  if (b != 5) {
                                                                    switchRateButtonColor(
                                                                        b, 0);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              '5',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )),
                                                      )
                                                    ]),
                                                SizedBox(height: 20),
                                                Expanded(
                                                  child: Container(
                                                    child: TextField(
                                                      controller: courseReview,
                                                      maxLines: 3,
                                                      decoration: InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              '리뷰를 작성해주세요(선택)'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 50,
                                                        child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              // 여기서 DB 연결 !!!
                                                              ReadController
                                                                  read =
                                                                  ReadController();
                                                              List<List<int>>
                                                                  selectList =
                                                                  await read.fb_read_user_selectList(
                                                                      readData
                                                                          .docCode,
                                                                      index);

                                                              List<String>
                                                                  traveledPlaceList =
                                                                  []; //여행다녔던 관광지들 1차원 배열
                                                              int placeNum = 0;
                                                              for (int p = 0;
                                                                  p < index;
                                                                  p++) {
                                                                placeNum += readData
                                                                        .placeNumList[
                                                                    p] as int;
                                                              }

                                                              int traveledPlaceNum =
                                                                  readData.placeNumList[
                                                                          index]
                                                                      as int;

                                                              for (int p =
                                                                      placeNum;
                                                                  p <
                                                                      placeNum +
                                                                          traveledPlaceNum;
                                                                  p++) {
                                                                traveledPlaceList
                                                                    .add(readData
                                                                        .traveledPlaceList[p]);
                                                              }

                                                              feedback(
                                                                  readData.travelList[
                                                                      index],
                                                                  traveledPlaceList,
                                                                  selectList,
                                                                  rate,
                                                                  courseReview
                                                                      .text);

                                                              widget.feedback =
                                                                  true;
                                                              //이러면 showDialog가 pop될걸?
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              //print('${rate}'); //별점
                                                              //print('${courseReview.text}'); //리뷰
                                                              //print('${journey}');
                                                            },
                                                            child: Text("리뷰 저장",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Neo",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ])));
                                    },
                                  );
                                },
                              );
                            }
                          },
                          child: Text("리뷰 작성",
                              style: TextStyle(
                                fontFamily: "Neo",
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                ),
              ]),
            )),
      ),
    );
  }
}
