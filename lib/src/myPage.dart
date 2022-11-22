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
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';

import 'myJourney.dart';

var readData;
//User readData;
List<List<CalendarEventData>> journeys = [];
Future readUserData(docCode) async {
  var read = ReadController();
  print('qdwq');

  readData = await read.fb_read_user(docCode) as User;
  //readData = await read.fb_read_user('docCodeTest1') as User;

  print(readData.name);

  journeys = []; //혹시 모르니 초기화 한번

  int jSave = 0;

  for (int i = 0; i < readData.eventNumList.length; i++) {
    List<CalendarEventData> tempList = [];
    for (int j = 0; j < readData.eventNumList[i]; j++) {
      tempList.add(readData.eventList[j + jSave] as CalendarEventData);
    }
    print(tempList[2].startTime);
    print(tempList[2].endTime);
    print(tempList[3].startTime);
    print(tempList[3].endTime);
    journeys.add(tempList);
    jSave = readData.eventNumList[i];
  }
}

//지금 DB에 넣어놓은 데이터가 시간순이 아니라 이상하게 보일 수 있음.

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
                              builder: (context) => MyJourney(
                                  journeys[i],
                                  [
                                    journeys[i][0].date,
                                    journeys[i][journeys[i].length - 1].date
                                  ],
                                  i)));
                      //i 인덱스도 넣어줌
                    }))
        ]));
  }
}
