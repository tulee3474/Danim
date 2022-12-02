import 'package:danim/src/date_selectlist.dart';
import 'package:danim/src/fixInfo.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../components/image_data.dart';
import '../map.dart';
import '../route_ai.dart';
import 'loading.dart';

class AttractionFix extends StatefulWidget {
  @override
  State<AttractionFix> createState() => _AttractionFixState();

  int transit = 0;

  AttractionFix(this.transit);
}

class _AttractionFixState extends State<AttractionFix> {
  String fixTourSpotName = '';
  double fixTourSpotLat = 0.0;
  double fixTourSpotLon = 0.0;

  int dayNum = endDay.difference(startDay).inDays;
  int dayDifference = endDay.difference(startDay).inDays + 1;
  int dayIndex = 0;

  get mapController => null;
  TextEditingController fixDateController = TextEditingController();

  @override
  void init() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  List<MaterialStateProperty<Color>> fixDayButtonColorList = [
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor)
  ];

  void switchFixDayButtonColor(int index, int type) {
    if (type == 1) {
      setState(() {
        fixDayButtonColorList[index] = MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        fixDayButtonColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  int fixDayIndex = -1;

  String location2 = "장소를 입력해주세요";

  void showPopUp(String message) {
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
                                ))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(message,
                                style: TextStyle(
                                  fontFamily: "Neo",
                                ))),
                      ),
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: InkWell(
          // onTap: () {
          //   Navigator.popUntil(context, (route) => route.isFirst);
          // },
          child: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40)
            ]),
          ),
        ),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.

          TextButton(
              onPressed: () {
                //Navigator.popUntil(context, (route) => route.isFirst);
                //첫화면까지 팝해버리는거임
              },
              child: Image.asset(IconsPath.count3,
                  fit: BoxFit.contain, width: 60, height: 50)),
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
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text('꼭 방문하길 원하는 장소가 있으신가요?',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text('예) 관광지, 카페, 맛집 등등',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Divider(color: Colors.grey, thickness: 2.0)),
              Center(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text("원하는 장소 입력",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 350,
                    height: 100.0,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: InkWell(
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                            mode: Mode.overlay,
                            language: "kr",
                            //types: [],
                            //strictbounds: false,
                            components: [Component(Component.country, 'kr')],
                            //google_map_webservice package
                            //onError: (err){
                            //  print(err);
                            //},
                          );

                          if (place != null) {
                            setState(() {
                              location2 = place.description.toString();
                            });

                            //form google_maps_webservice package
                            final plist = GoogleMapsPlaces(
                              apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                              //from google_api_headers package
                            );

                            String placeid = place.placeId ?? "0";

                            final detail =
                                await plist.getDetailsByPlaceId(placeid);
                            final geometry = detail.result.geometry!;
                            final lat = geometry.location.lat;
                            final lang = geometry.location.lng;
                            var newlatlang = LatLng(lat, lang);
                            //latLen.add(newlatlang);

                            //move map camera to selected place with animation
                            //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                            var places = location2.split(', ');
                            String placeName = places[places.length - 1];
                            print('$placeName placeName');

                            //관광지 이름, 위도, 경도 저장
                            setState(() {
                              fixTourSpotName = placeName;
                              fixTourSpotLat = lat;
                              fixTourSpotLon = lang;
                            });

                            placeList.add(Place(
                                placeName,
                                lat,
                                lang,
                                60,
                                20,
                                selectedList[0],
                                selectedList[1],
                                selectedList[2],
                                selectedList[3],
                                selectedList[4]));
                            setState(() {});
                            setState(() {});
                          } else {
                            setState(() {
                              location2 = "장소를 입력해주세요";
                            });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Card(
                            child: Container(
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width - 40,
                                child: ListTile(
                                  title: Text(
                                    location2,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: Icon(Icons.search),
                                  dense: true,
                                )),
                          ),
                        ))),
              ]),
              Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
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
              Center(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text("며칠 차 여행때 방문할 예정인가요?",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
              Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < dayDifference; i++)
                      Stack(children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                                      backgroundColor:
                                          fixDayButtonColorList[i]),
                                  onPressed: () {
                                    setState(() {
                                      fixDayIndex = i + 1;
                                      //버튼 색 변환
                                      switchFixDayButtonColor(i, 1);
                                      for (int b = 0; b < dayDifference; b++) {
                                        if (b != i) {
                                          switchFixDayButtonColor(b, 0);
                                        }
                                      }
                                    });

                                    print("selected day: ${i + 1}");
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
              Container(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 120.0,
                    height: 80.0,
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             AttractionFix(widget.transit)));
                          //픽스할 관광지 저장
                          if (fixTourSpotName != '') {
                            fixTourSpotList.add(Place(
                                fixTourSpotName,
                                fixTourSpotLat,
                                fixTourSpotLon,
                                60,
                                20,
                                selectedList[0],
                                selectedList[1],
                                selectedList[2],
                                selectedList[3],
                                selectedList[4]));

                            //픽스할 날짜 저장
                            if (fixDayIndex != -1) {
                              fixDateList.add(fixDayIndex);

                              //픽스 입력창 2개 리셋하기
                              fixTourSpotName = '';
                              fixTourSpotLat = 0.0;
                              fixTourSpotLon = 0.0;

                              setState(() {
                                location2 = "장소를 입력해주세요";
                              });

                              fixDayIndex = -1;

                              for (int b = 0; b < dayDifference; b++) {
                                switchFixDayButtonColor(b, 0);
                              }

                              //픽스 정보 잘 들어갔는지 출력
                              if (fixTourSpotList.length > 0) {
                                for (int f = 0;
                                    f < fixTourSpotList.length;
                                    f++) {
                                  print(
                                      '픽스 관광지 이름: ' + fixTourSpotList[f].name);
                                }

                                print(fixDateList);
                              }
                            } else {
                              showPopUp("날짜가 선택되지 않았습니다.");
                            }
                          } else {
                            showPopUp("장소가 선택되지 않았습니다.");
                          }
                        },
                        child: Text("장소 추가",
                            style: TextStyle(
                              fontFamily: "Neo",
                              fontWeight: FontWeight.bold,
                            )))),
              ),
              Container(
                  width: 120.0,
                  height: 80.0,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        // //픽스할 관광지 저장
                        // if (fixTourSpotName != '') {
                        //   fixTourSpotList.add(Place(
                        //       fixTourSpotName,
                        //       fixTourSpotLat,
                        //       fixTourSpotLon,
                        //       60,
                        //       20,
                        //       selectedList[0],
                        //       selectedList[1],
                        //       selectedList[2],
                        //       selectedList[3],
                        //       selectedList[4]));
                        // }

                        // //픽스할 날짜 저장
                        // if (fixDayIndex != -1) {
                        //   fixDateList.add(fixDayIndex);
                        // }

                        // //픽스 정보 잘 들어갔는지 출력
                        // if (fixTourSpotList.length > 0) {
                        //   print('픽스 관광지 이름: ' + fixTourSpotList[0].name);
                        //   print(fixDateList);
                        // }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loading(widget.transit)));
                      },
                      child: Text("다음 단계",
                          style: TextStyle(
                            fontFamily: "Neo",
                            fontWeight: FontWeight.bold,
                          ))))
            ])),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => AttractionFix(widget.transit)));
      //     },
      //     child: Icon(Icons.add))
    );
  }
}
