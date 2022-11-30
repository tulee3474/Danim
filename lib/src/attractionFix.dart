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

  String location2 = "장소를 입력해주세요.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/app');
              },
              child:
                  Image.asset(IconsPath.house, fit: BoxFit.contain, height: 20))
        ]),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('꼭 방문하길 원하는 관광지가 있으신가요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Row(children: [
              Container(
                  width: 300,
                  height: 50.0,
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
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
                            location2 = "장소를 입력해주세요.";
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
                                      fontFamily: "Neo",
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                trailing: Icon(Icons.search),
                                dense: true,
                              )),
                        ),
                      ))),
              Container(
                  width: 100.0,
                  height: 100.0,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextField(
                    controller: fixDateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '며칠차에?'),
                  ))
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 120.0,
                  height: 80.0,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AttractionFix(widget.transit)));
                      },
                      child: Text("관광지 추가",
                          style: TextStyle(
                            fontFamily: "Neo",
                          )))),
            ),
            Container(
                width: 120.0,
                height: 80.0,
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
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
                      }

                      //픽스할 날짜 저장
                      if (fixDateController.text != '') {
                        fixDateList.add(int.parse(fixDateController.text));
                      }

                      //픽스 정보 잘 들어갔는지 출력
                      if (fixTourSpotList.length > 0) {
                        print('픽스 관광지 이름: ' + fixTourSpotList[0].name);
                        print(fixDateList);
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Loading(widget.transit)));
                    },
                    child: Text("다음 단계",
                        style: TextStyle(
                          fontFamily: "Neo",
                        ))))
          ])),
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
