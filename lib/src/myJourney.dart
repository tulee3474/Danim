
import 'package:danim/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/myPage.dart';

class MyJourney extends StatefulWidget {
  List<CalendarEventData> journey = [];
  List<DateTime> dates = [];

  MyJourney(this.journey, this.dates);

  @override
  State<MyJourney> createState() => _MyJourneyState(journey, dates);
}

class _MyJourneyState extends State<MyJourney> {
  List<CalendarEventData> journey = [];
  List<DateTime> dates = [];
  List<String> diaries = [];

  TextEditingController courseReview = TextEditingController(); //코스 리뷰 저장되는 컨트롤러
  int rate = 0; //코스 별점


  _MyJourneyState(this.journey, this.dates);

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
            onPressed:() {
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
                                labelText: '리뷰'
                              ),
                              ),


                            ElevatedButton(
                                onPressed: (){

                                  // 여기서 DB 연결 !!!


                                  print('${rate}');//별점
                                  print('${courseReview.text}');//리뷰
                                  print('${journey}');

                                },
                                child: Text("리뷰 저장"))

                          ])));

                }
              );
            },
            child: Icon(Icons.rate_review)
          ),

          TextButton(
            child: Icon(Icons.trip_origin),
            onPressed:(){

              //여기서 timetable 다시 띄우기









            }
          )

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
                    onPressed: () => {
                          for (int i = 0; i < dates.length; i++)
                            diaries.add(textControllers[i].text),

                      //여기서 DB로 넘기면 됨 !!!!!
                          print(diaries),
                        }))
          ])),
    );
  }
}
