import 'package:danim/src/createMovingTimeList.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/src/place.dart';
import 'package:danim/map.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../route.dart';
import 'courseSelected.dart';
//import 'exampleResource.dart';\

class Preset extends StatefulWidget {
  List<List<List<Place>>> pathList;
  int transit = 0;

  //Preset(pathList, this.transit);
  Preset(this.pathList, this.transit, {super.key});

  @override
  State<Preset> createState() => _PresetState();
}

class _PresetState extends State<Preset> {
  int presetIndex = 0;

  // String str = '';
  // void setState(VoidCallback fn) {
  //   str += "in SetState\n";
  //   super.setState(fn);
  // }

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

  List<MaterialStateProperty<Color>> presetButtonColorList = [
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor)
  ];

  // List<TextStyle> presetButtonTextColorList = [
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   )
  // ];

  void switchPresetButtonColor(int index, int type) {
    if (type == 1) {
      setState(() {
        presetButtonColorList[index] = MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        presetButtonColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('여행 코스 선택(4/4)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          actions: [
            //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
            //이곳에 한개 이상의 위젯들을 가진다.

            // TextButton(
            //     onPressed: () {
            //       //Navigator.popUntil(context, (route) => route.isFirst);
            //       //첫화면까지 팝해버리는거임
            //     },
            //     child: Image.asset(
            //       IconsPath.count2,
            //       fit: BoxFit.contain,
            //       width: 60,
            //       height: 40,
            //     )),
            IconButton(
              icon: Icon(Icons.home),
              tooltip: 'Hi!',
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                //첫화면까지 팝해버리는거임
              },
            ),
            // TextButton(
            //     onPressed: () {
            //       Navigator.popUntil(context, (route) => route.isFirst);
            //       //첫화면까지 팝해버리는거임
            //     },
            //     child: Image.asset(
            //       IconsPath.house,
            //       fit: BoxFit.contain,
            //       height: 20,
            //     )),
          ],
        ),
        body: Column(children: [
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Container(
          //       padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          //       child: Text('다음 프리셋 중 하나를 골라주세요!',
          //           style: TextStyle(
          //             color: Colors.black,
          //             letterSpacing: 2.0,
          //             fontSize: 18.0,
          //             fontFamily: "Neo",
          //             fontWeight: FontWeight.bold,
          //           ))),
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('아래의 여행 코스 중 하나를 골라주세요!',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Neo",
                      letterSpacing: 2.0,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ))),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text('마커를 눌러 관광지를 확인해보세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Neo",
                    //letterSpacing: 2.0,
                    fontSize: 11.0,
                    //fontWeight: FontWeight.bold,
                  ))),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 7,
            decoration: BoxDecoration(
              color: Color(0xffF4F4F4),
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xffD4D4D4)),
              ),
            ),
          ),
          Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
              ),
              child: NaverMap(
                onMapCreated: (mcontroller) {
                  setState(() {
                    mapController = mcontroller;
                  });
                },
                initialCameraPosition: CameraPosition(
                    bearing: 0.0,
                    target: LatLng(33.371964, 126.543512),
                    tilt: 0.0,
                    zoom: 8.0),
                mapType: _mapType,
                markers: markers,
                pathOverlays: pathOverlays,
              ) // 여기서 지도 넣으면 돼!! 컨테이너 대신에 네이버맵 넣으면 될듯
              ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 7,
            decoration: BoxDecoration(
              color: Color(0xffF4F4F4),
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xffD4D4D4)),
              ),
            ),
          ),
          SizedBox(
            width: 200, // 너비 추가
            height: 30, // 높이 추가
            // child: Container(
            //   color: Colors.blue,
            //   child: Text("Container"),
            // ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            for (int i = 0; i < widget.pathList.length; i++)
              Stack(children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
                    child: Container(
                      height: 40.0,
                      child: ElevatedButton(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          //이거 나중에 인덱스 초기화 에러 조심할 것! 관광지 갯수가 적으면..
                          style: ButtonStyle(
                              backgroundColor: presetButtonColorList[i]),
                          onPressed: () {
                            setState(() {
                              presetIndex = i;
                              print('presetIndex $presetIndex');
                              addPresetPoly(widget.pathList[presetIndex]);
                              print('preset ${widget.pathList[presetIndex]}');
                              addPresetMarker(widget.pathList[presetIndex]);

                              //버튼 색 변환
                              switchPresetButtonColor(i, 1);
                              for (int b = 0; b < widget.pathList.length; b++) {
                                if (b != i) {
                                  switchPresetButtonColor(b, 0);
                                }
                              }
                            });

                            print("selected preset: ${i + 1}");
                          }),
                    )),
                // Positioned(
                //     right: -20,
                //     child: Container(
                //         child: TextButton(
                //             child: Icon(Icons.arrow_forward, color: Colors.red),
                //             onPressed: () => {print(widget.pathList[i])})))
              ]),
          ]),
          SizedBox(
            width: 200, // 너비 추가
            height: 50, // 높이 추가
            // child: Container(
            //   color: Colors.blue,
            //   child: Text("Container"),
            // ),
          ),
          Center(
              child: Container(
            width: 120.0,
            height: 50.0,
            child: ElevatedButton(
                child: Text('프리셋 선택',
                    style: TextStyle(
                      fontFamily: "Neo",
                      //letterSpacing: 2.0,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () async {
                  //선택한 코스 전역변수에 저장
                  course_selected = widget.pathList[presetIndex];

                  if (widget.transit == 0) {
                    List<List<int>> movingTimeList = [
                      for (int i = 0;
                          i < widget.pathList[presetIndex].length;
                          i++)
                        []
                    ];

                    movingTimeList = await createDrivingTimeList(
                        widget.pathList[presetIndex]);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Timetable(
                                  preset: widget.pathList[presetIndex],
                                  transit: widget.transit,
                                  movingTimeList: movingTimeList,
                                )));
                  } else {
                    List<List<int>> movingTimeList = [
                      for (int i = 0;
                          i < widget.pathList[presetIndex].length;
                          i++)
                        []
                    ];

                    movingTimeList = await createTransitTimeList(
                        widget.pathList[presetIndex]);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Timetable(
                                  preset: widget.pathList[presetIndex],
                                  transit: widget.transit,
                                  movingTimeList: movingTimeList,
                                )));
                  }
                }),
          )),
        ]));
  }
}
