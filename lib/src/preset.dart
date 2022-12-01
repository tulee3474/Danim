import 'package:danim/src/createMovingTimeList.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/src/place.dart';
import 'package:danim/map.dart' as map;

import '../route.dart';
import 'courseSelected.dart';
//import 'exampleResource.dart';\


class Preset extends StatelessWidget {
  List<List<List<Place>>> pathList;
  int transit = 0;
  //Preset(pathList, this.transit);
  Preset(this.pathList, this.transit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  //첫화면까지 팝해버리는거임
                },
                child: Image.asset(IconsPath.house,
                    fit: BoxFit.contain, height: 20))
          ]),
        ),
        body:  Column(
                children:[

                  Container(height: 400,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),

                      ),
                      child:Container() // 여기서 지도 넣으면 돼!! 컨테이너 대신에 네이버맵 넣으면 될듯
                  )
                  ,
            Row(children: <Widget>[
              for (int i = 0; i < pathList.length; i++)
                Stack(children: [
                  Padding(
                    
                      padding: EdgeInsets.fromLTRB(11,0,0,0),
                      child: ElevatedButton(
                          child: Text(
                              '${i+1}'),
                          //이거 나중에 인덱스 초기화 에러 조심할 것! 관광지 갯수가 적으면..
                          onPressed: () async {

                            //선택한 코스 전역변수에 저장
                            course_selected = pathList[i];





                            //map.addMarker(pathList[i]);
                            //map.addPoly(pathList[i]);

                            if (transit == 0) {
                              List<List<int>> movingTimeList = [
                                for (int i = 0; i < pathList[i].length; i++) []
                              ];

                              movingTimeList =
                                  await createDrivingTimeList(pathList[i]);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Timetable(
                                            preset: pathList[i],
                                            transit: transit,
                                            movingTimeList: movingTimeList,
                                          )));
                            } else {
                              List<List<int>> movingTimeList = [
                                for (int i = 0; i < pathList[i].length; i++) []
                              ];

                              movingTimeList =
                                  await createTransitTimeList(pathList[i]);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Timetable(
                                            preset: pathList[i],
                                            transit: transit,
                                            movingTimeList: movingTimeList,
                                          )));
                            }
                          })),
                  Positioned(
                      right: -20,
                      child: Container(
                          child: TextButton(
                              child:
                                  Icon(Icons.arrow_forward, color: Colors.red),
                              onPressed: () => {print(pathList[i])})))
                ]),
              
            ])]));
  }
}
