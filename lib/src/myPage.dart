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
List<String> diaries = [];
Future readUserData(docCode) async {
  var read = ReadController();
  print('qdwq');

  journeys = []; //혹시 모르니 초기화 한번
  diaries = [];

  try {
    readData = await read.fb_read_user(docCode) as User;
    //readData = await read.fb_read_user('docCodeTest1') as User;
    print(readData.name);
    int jSave = 0;

    for (int i = 0; i < readData.eventNumList.length; i++) {
      List<CalendarEventData> tempList = [];
      for (int j = 0; j < readData.eventNumList[i]; j++) {
        tempList.add(readData.eventList[j + jSave] as CalendarEventData);
      }
      journeys.add(tempList);
      jSave = readData.eventNumList[i];
    }

    for (int i = 0; i < readData.diaryList.length; i++) {
      diaries.add(readData.diaryList[i]);
    }
  } catch (e) {
    print("저장된 코스가 없습니다.");
  }
}

//지금 DB에 넣어놓은 데이터가 시간순이 아니라 이상하게 보일 수 있음.

/*
!!! 다른 사람 코스 불러오는 함수

Future<User> fb_read_other_course(String docCodeNum)
    docCodeNum - docCode/num 형태, num은 1, 2, 3, 4 - event뒤의 숫자와 동일
*/

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //https://wikidocs.net/168968 참고
    return WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, (route) => route.isFirst);
          //첫화면까지 팝해버리는거임
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: InkWell(
                // onTap: () {
                //   Navigator.popUntil(context, (route) => route.isFirst);
                // },
                child: Transform(
                  transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(IconsPath.logo,
                            fit: BoxFit.contain, height: 40)
                      ]),
                ),
              ),
              actions: [
                //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
                //이곳에 한개 이상의 위젯들을 가진다.

                // TextButton(
                //     onPressed: () {
                //       //Navigator.popUntil(context, (route) => route.isFirst);
                //       //첫화면까지 팝해버리는거임
                //     },
                //     child: Image.asset(IconsPath.count4,
                //         fit: BoxFit.contain, width: 60, height: 50)),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      //첫화면까지 팝해버리는거임
                    },
                    child: Image.asset(IconsPath.house,
                        fit: BoxFit.contain, height: 30)),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text('내 여행 목록',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Divider(color: Colors.grey, thickness: 2.0)),
                for (int i = 0; i < journeys.length; i++)
                  Container(
                      height: 60.0,
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          child: Text(
                              '${i + 1}' +
                                  '. ' +
                                  '${readData.travelList[i]}' +
                                  '여행 : '
                                      '${journeys[i][0].date.year}' +
                                  '.' +
                                  '${journeys[i][0].date.month}' +
                                  '.' +
                                  '${journeys[i][0].date.day}' +
                                  ' - '
                                      //     '${journeys[i][journeys[i].length - 1].date.year}' +
                                      // '.' +
                                      '${journeys[i][journeys[i].length - 1].date.month}' +
                                  '.' +
                                  '${journeys[i][journeys[i].length - 1].date.day}',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            print(
                                'journeys_위도 마이페이지에서 확인 : ${journeys[i][0].latitude}');

                            print(
                                'journeys_위도 마이페이지에서 확인 : ${journeys[i][0].latitude}');

                            //이미 저장된 일기 있는지 확인
                            String previousDiary = '';
                            if (i < diaries.length) {
                              previousDiary = diaries[i];
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyJourney(
                                        journeys[i],
                                        [
                                          journeys[i][0].date,
                                          journeys[i][journeys[i].length - 1]
                                              .date
                                        ],
                                        i,
                                        previousDiary)));
                            //i 인덱스도 넣어줌
                          }))
              ]),
            )));
  }
}
