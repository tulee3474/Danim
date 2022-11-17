import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
//import 'package:danim/src/place.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'exampleResource.dart';
import 'package:danim/firebase_read_write.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Preset extends StatelessWidget {
  List<List<List<Place>>> pathList;

  //임시 이동시간 배열
  List<int> moving_time_ex = [1, 2, 1, 1, 3, 2, 1, 1];

  Preset(this.pathList);

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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
                child: Column(children: <Widget>[
              for (int i = 0; i < pathList.length; i++)
                Stack(children: [
                  Container(
                      child: ElevatedButton(
                          child: Text(
                              '${pathList[i][0][0].name} + ${pathList[i][0][1].name}...'),
                          //이거 나중에 인덱스 초기화 에러 조심할 것! 관광지 갯수가 적으면..
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Timetable(
                                            pathList[i][0], moving_time_ex)))
                              })),
                  Positioned(
                      right: -20,
                      child: Container(
                          child: TextButton(
                              child:
                                  Icon(Icons.arrow_forward, color: Colors.red),
                              onPressed: () => {print(pathList[i])})))
                ]),
            ]))));
  }
}
