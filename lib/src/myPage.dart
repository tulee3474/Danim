import 'package:danim/calendar_view.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
//import 'package:danim/src/exampleResource.dart';
import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import '../model/event.dart';

import 'myJourney.dart';

var readData;
//User readData;
List<List<CalendarEventData>> journeys = [];
Future readUserData(docCode) async {
  var read = ReadController();

  readData = await read.fb_read_user(docCode) as User;

  journeys = []; //혹시 모르니 초기화 한번

  int jSave = 0;

  for (int i = 0; i < readData.eventNumList.length; i++) {
    List<CalendarEventData> tempList = [];
    for (int j = 0; j < readData.eventNumList[i]; j++) {
      tempList.add(readData.eventList[j + jSave] as CalendarEventData);
    }
    journeys.add(tempList);
    jSave = readData.eventNumList[i];
  }
}

List<DateTime> dates_ex = [DateTime(2022, 5, 14), DateTime(2022, 5, 15)];
//이건 뭔지 몰라서 놔둠.

class MyPage extends StatelessWidget {
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
        body: Column(children: [
          Container(
              alignment: FractionalOffset.centerLeft,
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text("내 여정 목록")),
          Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Divider(color: Colors.grey, thickness: 2.0)),
          for (int i = 0; i < journeys.length; i++)
            Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                alignment: Alignment.centerLeft,
                child: TextButton(
                    child: Text('${i + 1}' +
                        '. ' +
                        '${journeys[i][0].date.year}' +
                        '.' +
                        '${journeys[i][0].date.month}' +
                        '.' +
                        '${journeys[i][0].date.day}' +
                        ' - '
                            '${journeys[i][journeys[i].length - 1].date.year}' +
                        '.' +
                        '${journeys[i][journeys[i].length - 1].date.month}' +
                        '.' +
                        '${journeys[i][journeys[i].length - 1].date.day}'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyJourney(journeys[i], dates_ex)));
                    }))
        ]));
  }
}
