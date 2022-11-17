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
                  Image.asset(IconsPath.back, fit: BoxFit.contain, height: 20))
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
                          print(diaries)
                        }))
          ])),
    );
  }
}
