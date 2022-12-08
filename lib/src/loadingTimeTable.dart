import 'dart:async';

import 'package:danim/src/createMovingTimeList.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/src/place.dart';
import 'package:danim/map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../route.dart';
import 'courseSelected.dart';

class LoadingTimeTable extends StatefulWidget{

  List<List<Place>> preset = [];
  int transit = 0;
  //List<List<int>> movingTimeList = [];
  int startDayTime = 0;
  int endDayTime = 0;
  //List<List<String>> movingStepsList = [];


  LoadingTimeTable(
      this.preset,
      this.transit,
      this.startDayTime,
      this.endDayTime,
      );

/*
  Timetable(
  preset: widget.pathList[presetIndex],
  transit: widget.transit,
  movingTimeList: movingTimeList,
  startDayTime: dayStartingTime.hour,
  endDayTime: dayEndingTime.hour,
  movingStepsList: movingStepsList,
  )

 */

  @override
  State<LoadingTimeTable> createState() => _LoadingTimeTableState();
}

class _LoadingTimeTableState extends State<LoadingTimeTable>{

  qqqq() async {


    List<List<int>> movingTimeList = [
      for (int i = 0;
      i < widget.preset.length;
      i++)
        []
    ];
    List<List<String>> movingStepsList = [
      for (int i = 0;
      i < widget.preset.length;
      i++)
        []
    ];


    if (widget.transit == 0) {
     movingTimeList = await createDrivingTimeList(widget.preset);



      Timer(Duration(seconds: 0), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Timetable(
                      preset: widget.preset,
                      transit: widget.transit,
                      movingTimeList: movingTimeList,
                      startDayTime: widget.startDayTime,
                      endDayTime: widget.endDayTime,
                      movingStepsList: movingStepsList,
                    )));
      });
    }

    else {
      movingTimeList = await createTransitTimeList(widget.preset);
      movingStepsList = await createTransitStepsList(widget.preset);



      Timer(Duration(seconds: 0), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Timetable(
                      preset: widget.preset,
                      transit: widget.transit,
                      movingTimeList: movingTimeList,
                      startDayTime: widget.startDayTime,
                      endDayTime: widget.endDayTime,
                      movingStepsList: movingStepsList,
                    )));
      });
    }
  }


  @override
  initState(){
    super.initState();
    qqqq();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true, // 앱바 가운데 정렬
        title: InkWell(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(children: [
          Container(padding: EdgeInsets.fromLTRB(0, 250, 0, 0)),
          Center(child: SpinKitRing(color: Colors.grey)),
          SizedBox(height:15),
          Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text("타임 테이블을 생성하고 있입니다.",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
        ]),
      )
    );
  }
}
