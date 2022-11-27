import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/timetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:danim/src/courseDetail.dart';
import 'package:danim/src/myPage.dart';
import 'package:danim/src/start_end_day.dart';

import 'package:danim/src/login.dart';

import '../map.dart';
import '../route_ai.dart';
import 'accomodationInfo.dart';
import 'community.dart';
import 'date_selectlist.dart';
import 'fixInfo.dart';

void main() {
  runApp(MaterialApp(
    title: 'DANIM',
    home: App(),
  ));
}
final GoogleSignIn googleSignIn = new GoogleSignIn();
// variable for firestore collection 'users'
final userReference = FirebaseFirestore.instance.collection('users');

//final DateTime timestamp = DateTime.now();
User? currentUser;
String? userName='';
String? userEmail='';
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _accomodationController = TextEditingController();

  DateTime? tempPickedDate;



  buildLogedinScreen() {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 60)
              ]),
            ),
            endDrawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
                  UserAccountsDrawerHeader(
                      accountName: Text('$userName'),
                      accountEmail: Text('$userEmail')),
                  ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text("설정"),
                      onTap: () => {print("Setting")}),
                  ListTile(
                      leading: Icon(Icons.login, color: Colors.grey),
                      title: Text('로그아웃'),
                      onTap: () => {

                        //로그아웃
                      FirebaseAuth.instance.signOut(),
                      googleSignIn.signOut()

                        //Navigator.push(context,
                        //MaterialPageRoute(builder: (context) => Login()))

                      }),
                ])),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: EdgeInsets.all(20),
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  //숙소정보 초기화
                                  accomodation = '';
                                  accomodation_lati = 0;
                                  accomodation_long = 0;

                                  //selectedList 초기화
                                  selectedList = [
                                    [0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0]
                                  ];

                                  //픽스 관광지 정보 초기화
                                  fixTourSpotNameList = [];
                                  fixDateList = [];

                                  //가는 날, 오는 날 초기화
                                  startDay = DateTime.now();
                                  endDay = DateTime.now();

                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SizedBox(
                                                  height: 600.0,
                                                  width: 300,
                                                  child: Column(
                                                      children: <Widget>[
                                                        Column(
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 180.0,
                                                                  child: TextFormField(
                                                                      initialValue:
                                                                      "제주도",
                                                                      decoration: InputDecoration(
                                                                          border:
                                                                          OutlineInputBorder(),
                                                                          labelText:
                                                                          '지역'))),
                                                              Container(
                                                                width: 180.0,
                                                                child: SafeArea(
                                                                    child:
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left: 15,
                                                                          right:
                                                                          15),
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Padding(
                                                                                padding:
                                                                                const EdgeInsets.only(top: 10)),
                                                                            GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  HapticFeedback.mediumImpact();
                                                                                  _selectedDataCalendar_startDay(context);
                                                                                },
                                                                                child: AbsorbPointer(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 16),
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                          isDense: true,
                                                                                          hintText: "가는 날",
                                                                                          enabledBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                                          ),
                                                                                          focusedBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.red),
                                                                                          ),
                                                                                        ),
                                                                                        controller: _startDateController,
                                                                                      ),
                                                                                    )))
                                                                          ]),
                                                                    )),
                                                              ),

                                                              Container(
                                                                width: 180.0,
                                                                child: SafeArea(
                                                                    child:
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left: 15,
                                                                          right:
                                                                          15),
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Padding(
                                                                                padding:
                                                                                const EdgeInsets.only(top: 10)),
                                                                            GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  HapticFeedback.mediumImpact();
                                                                                  _selectedDataCalendar_endDay(context);
                                                                                },
                                                                                child: AbsorbPointer(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 16),
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                          isDense: true,
                                                                                          hintText: "오는 날",
                                                                                          enabledBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                                          ),
                                                                                          focusedBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.red),
                                                                                          ),
                                                                                        ),
                                                                                        controller: _endDateController,
                                                                                      ),
                                                                                    )))
                                                                          ]),
                                                                    )),
                                                              ),

                                                              ////
                                                            ]),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                0, 0),
                                                            child: Text(
                                                                "미리 정해놓은 숙소가 있다면 알려주세요")),
                                                        InkWell(
                                                            onTap: () async {
                                                              var place =
                                                              await PlacesAutocomplete
                                                                  .show(
                                                                context:
                                                                context,
                                                                apiKey:
                                                                'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                mode: Mode
                                                                    .overlay,
                                                                language: "kr",
                                                                //types: [],
                                                                //strictbounds: false,
                                                                components: [
                                                                  Component(
                                                                      Component
                                                                          .country,
                                                                      'kr')
                                                                ],
                                                                //google_map_webservice package
                                                                //onError: (err){
                                                                //  print(err);
                                                                //},
                                                              );

                                                              if (place !=
                                                                  null) {
                                                                setState(() {
                                                                  location = place
                                                                      .description
                                                                      .toString();
                                                                });

                                                                //form google_maps_webservice package
                                                                final plist =
                                                                GoogleMapsPlaces(
                                                                  apiKey:
                                                                  'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                  apiHeaders:
                                                                  await GoogleApiHeaders()
                                                                      .getHeaders(),
                                                                  //from google_api_headers package
                                                                );

                                                                String placeid =
                                                                    place.placeId ??
                                                                        "0";

                                                                final detail =
                                                                await plist
                                                                    .getDetailsByPlaceId(
                                                                    placeid);
                                                                final geometry =
                                                                detail
                                                                    .result
                                                                    .geometry!;
                                                                final lat =
                                                                    geometry
                                                                        .location
                                                                        .lat;
                                                                final lang =
                                                                    geometry
                                                                        .location
                                                                        .lng;
                                                                var newlatlang =
                                                                LatLng(lat,
                                                                    lang);
                                                                accommodationLatLen
                                                                    .add(
                                                                    newlatlang);

                                                                //move map camera to selected place with animation
                                                                //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                                                var places =
                                                                location
                                                                    .split(
                                                                    ', ');
                                                                String
                                                                placeName =
                                                                places[places
                                                                    .length -
                                                                    1];
                                                                print(
                                                                    'placeName: $placeName');

                                                                //숙소 정보 업데이트
                                                                accomodation =
                                                                    placeName;
                                                                accomodation_lati =
                                                                    lat;
                                                                accomodation_long =
                                                                    lang;

                                                                //관광지 이름
                                                                var fixTourSpotName =
                                                                    placeName;

                                                                placeList.add(Place(
                                                                    placeName,
                                                                    lat,
                                                                    lang,
                                                                    60,
                                                                    20,
                                                                    selectedList[
                                                                    0],
                                                                    selectedList[
                                                                    1],
                                                                    selectedList[
                                                                    2],
                                                                    selectedList[
                                                                    3],
                                                                    selectedList[
                                                                    4]));
                                                                setState(() {});
                                                                setState(() {});
                                                              } else {
                                                                setState(() {
                                                                  location =
                                                                  "Search Location";
                                                                });
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(15),
                                                              child: Card(
                                                                child:
                                                                Container(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        0),
                                                                    width: MediaQuery.of(context).size.width -
                                                                        40,
                                                                    child:
                                                                    ListTile(
                                                                      title:
                                                                      Text(
                                                                        location,
                                                                        style:
                                                                        TextStyle(fontSize: 18),
                                                                      ),
                                                                      trailing:
                                                                      Icon(Icons.search),
                                                                      dense:
                                                                      true,
                                                                    )),
                                                              ),
                                                            )),
                                                        Container(
                                                            width: 100.0,
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 30,
                                                                0, 0),
                                                            child:
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  //인풋값들 출력 확인
                                                                  //숙소값, 가는날, 오는만 있어야 정상.

                                                                  print(
                                                                      "accomodation : ${accomodation}");
                                                                  print(
                                                                      "accomo latitude: $accomodation_lati");
                                                                  print(
                                                                      "accomo longitude: $accomodation_long");
                                                                  print(
                                                                      "selectedList : ${selectedList}");
                                                                  print(
                                                                      "fixTourSpotNameList: ${fixTourSpotNameList}");
                                                                  print(
                                                                      "fixDateList : ${fixDateList}");
                                                                  print(
                                                                      "startDay : $startDay");
                                                                  print(
                                                                      "endDay: $endDay");

                                                                  print(
                                                                      "며칠? ${endDay.difference(startDay).inDays + 1}");

                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => CourseDetail()));
                                                                },
                                                                child: Text(
                                                                    '추천코스'))),
                                                        Container(
                                                            width: 100.0,
                                                            child:
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  List<List<Place>>
                                                                  emptyPreset =
                                                                  [[]];

                                                                  /*
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Timetable(preset: emptyPreset,transit: 0)));
*/
                                                                },
                                                                child: Text(
                                                                    '혼자 짤래요')))
                                                      ]),
                                                )));
                                      });
                                },
                                child: Text('새 코스'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () async {
                                  //임시 텍스트
                                  if (token == '') {
                                    await readUserData("docCodeTest123");
                                  } else {
                                    await readUserData(token as String);
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyPage()));
                                },
                                child: Text('내 여행'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () async {
                                  await readPostData();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Community()));
                                },
                                child: Text('커뮤니티'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100)))
                          ])),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: 400,
                      child: Divider(color: Colors.grey, thickness: 2.0)),
                  Column(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('# 지금, 당신 근처에',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ))),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Image.asset('assets/images/jenu1.jpeg',
                              width: 300, height: 200),
                          Image.asset('assets/images/jeju2.jpeg',
                              width: 300, height: 200)
                        ])),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        width: 400,
                        child: Divider(color: Colors.grey, thickness: 2.0)),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('# 만연한 가을, 단풍 속으로',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ))),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Image.asset('assets/images/jeju3.jpeg',
                              width: 300, height: 200),
                          Image.asset('assets/images/jeju2.jpeg',
                              width: 300, height: 200)
                        ])),
                  ])
                ]))),
        onWillPop: () async {
          return false;
        });
  }

  buildLoginScreen() {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 60)
              ]),
            ),
            endDrawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
                  UserAccountsDrawerHeader(
                      accountName: Text('로그인을 하세요!'),
                      accountEmail: Text('')),
                  ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text("설정"),
                      onTap: () => {print("Setting")}),
                  ListTile(
                      leading: Icon(Icons.login, color: Colors.grey),
                      title: Text('로그인'),
                      onTap: () => {


                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()))

                      }),
                ])),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          buttonPadding: EdgeInsets.all(20),
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  //숙소정보 초기화
                                  accomodation = '';
                                  accomodation_lati = 0;
                                  accomodation_long = 0;

                                  //selectedList 초기화
                                  selectedList = [
                                    [0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0]
                                  ];

                                  //픽스 관광지 정보 초기화
                                  fixTourSpotNameList = [];
                                  fixDateList = [];

                                  //가는 날, 오는 날 초기화
                                  startDay = DateTime.now();
                                  endDay = DateTime.now();

                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SizedBox(
                                                  height: 600.0,
                                                  width: 300,
                                                  child: Column(
                                                      children: <Widget>[
                                                        Column(
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 180.0,
                                                                  child: TextFormField(
                                                                      initialValue:
                                                                      "제주도",
                                                                      decoration: InputDecoration(
                                                                          border:
                                                                          OutlineInputBorder(),
                                                                          labelText:
                                                                          '지역'))),
                                                              Container(
                                                                width: 180.0,
                                                                child: SafeArea(
                                                                    child:
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left: 15,
                                                                          right:
                                                                          15),
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Padding(
                                                                                padding:
                                                                                const EdgeInsets.only(top: 10)),
                                                                            GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  HapticFeedback.mediumImpact();
                                                                                  _selectedDataCalendar_startDay(context);
                                                                                },
                                                                                child: AbsorbPointer(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 16),
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                          isDense: true,
                                                                                          hintText: "가는 날",
                                                                                          enabledBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                                          ),
                                                                                          focusedBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.red),
                                                                                          ),
                                                                                        ),
                                                                                        controller: _startDateController,
                                                                                      ),
                                                                                    )))
                                                                          ]),
                                                                    )),
                                                              ),

                                                              Container(
                                                                width: 180.0,
                                                                child: SafeArea(
                                                                    child:
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left: 15,
                                                                          right:
                                                                          15),
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Padding(
                                                                                padding:
                                                                                const EdgeInsets.only(top: 10)),
                                                                            GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  HapticFeedback.mediumImpact();
                                                                                  _selectedDataCalendar_endDay(context);
                                                                                },
                                                                                child: AbsorbPointer(
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                                                                                      child: TextFormField(
                                                                                        style: TextStyle(fontSize: 16),
                                                                                        decoration: InputDecoration(
                                                                                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                          isDense: true,
                                                                                          hintText: "오는 날",
                                                                                          enabledBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                                          ),
                                                                                          focusedBorder: UnderlineInputBorder(
                                                                                            borderSide: BorderSide(color: Colors.red),
                                                                                          ),
                                                                                        ),
                                                                                        controller: _endDateController,
                                                                                      ),
                                                                                    )))
                                                                          ]),
                                                                    )),
                                                              ),

                                                              ////
                                                            ]),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                0, 0),
                                                            child: Text(
                                                                "미리 정해놓은 숙소가 있다면 알려주세요")),
                                                        InkWell(
                                                            onTap: () async {
                                                              var place =
                                                              await PlacesAutocomplete
                                                                  .show(
                                                                context:
                                                                context,
                                                                apiKey:
                                                                'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                mode: Mode
                                                                    .overlay,
                                                                language: "kr",
                                                                //types: [],
                                                                //strictbounds: false,
                                                                components: [
                                                                  Component(
                                                                      Component
                                                                          .country,
                                                                      'kr')
                                                                ],
                                                                //google_map_webservice package
                                                                //onError: (err){
                                                                //  print(err);
                                                                //},
                                                              );

                                                              if (place !=
                                                                  null) {
                                                                setState(() {
                                                                  location = place
                                                                      .description
                                                                      .toString();
                                                                });

                                                                //form google_maps_webservice package
                                                                final plist =
                                                                GoogleMapsPlaces(
                                                                  apiKey:
                                                                  'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                  apiHeaders:
                                                                  await GoogleApiHeaders()
                                                                      .getHeaders(),
                                                                  //from google_api_headers package
                                                                );

                                                                String placeid =
                                                                    place.placeId ??
                                                                        "0";

                                                                final detail =
                                                                await plist
                                                                    .getDetailsByPlaceId(
                                                                    placeid);
                                                                final geometry =
                                                                detail
                                                                    .result
                                                                    .geometry!;
                                                                final lat =
                                                                    geometry
                                                                        .location
                                                                        .lat;
                                                                final lang =
                                                                    geometry
                                                                        .location
                                                                        .lng;
                                                                var newlatlang =
                                                                LatLng(lat,
                                                                    lang);
                                                                accommodationLatLen
                                                                    .add(
                                                                    newlatlang);

                                                                //move map camera to selected place with animation
                                                                //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                                                var places =
                                                                location
                                                                    .split(
                                                                    ', ');
                                                                String
                                                                placeName =
                                                                places[places
                                                                    .length -
                                                                    1];
                                                                print(
                                                                    'placeName: $placeName');

                                                                //숙소 정보 업데이트
                                                                accomodation =
                                                                    placeName;
                                                                accomodation_lati =
                                                                    lat;
                                                                accomodation_long =
                                                                    lang;

                                                                //관광지 이름
                                                                var fixTourSpotName =
                                                                    placeName;

                                                                placeList.add(Place(
                                                                    placeName,
                                                                    lat,
                                                                    lang,
                                                                    60,
                                                                    20,
                                                                    selectedList[
                                                                    0],
                                                                    selectedList[
                                                                    1],
                                                                    selectedList[
                                                                    2],
                                                                    selectedList[
                                                                    3],
                                                                    selectedList[
                                                                    4]));
                                                                setState(() {});
                                                                setState(() {});
                                                              } else {
                                                                setState(() {
                                                                  location =
                                                                  "Search Location";
                                                                });
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(15),
                                                              child: Card(
                                                                child:
                                                                Container(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        0),
                                                                    width: MediaQuery.of(context).size.width -
                                                                        40,
                                                                    child:
                                                                    ListTile(
                                                                      title:
                                                                      Text(
                                                                        location,
                                                                        style:
                                                                        TextStyle(fontSize: 18),
                                                                      ),
                                                                      trailing:
                                                                      Icon(Icons.search),
                                                                      dense:
                                                                      true,
                                                                    )),
                                                              ),
                                                            )),
                                                        Container(
                                                            width: 100.0,
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 30,
                                                                0, 0),
                                                            child:
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  //인풋값들 출력 확인
                                                                  //숙소값, 가는날, 오는만 있어야 정상.

                                                                  print(
                                                                      "accomodation : ${accomodation}");
                                                                  print(
                                                                      "accomo latitude: $accomodation_lati");
                                                                  print(
                                                                      "accomo longitude: $accomodation_long");
                                                                  print(
                                                                      "selectedList : ${selectedList}");
                                                                  print(
                                                                      "fixTourSpotNameList: ${fixTourSpotNameList}");
                                                                  print(
                                                                      "fixDateList : ${fixDateList}");
                                                                  print(
                                                                      "startDay : $startDay");
                                                                  print(
                                                                      "endDay: $endDay");

                                                                  print(
                                                                      "며칠? ${endDay.difference(startDay).inDays + 1}");

                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => CourseDetail()));
                                                                },
                                                                child: Text(
                                                                    '추천코스'))),
                                                        Container(
                                                            width: 100.0,
                                                            child:
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  List<List<Place>>
                                                                  emptyPreset =
                                                                  [[]];

                                                                  /*
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Timetable(preset: emptyPreset,transit: 0)));
*/
                                                                },
                                                                child: Text(
                                                                    '혼자 짤래요')))
                                                      ]),
                                                )));
                                      });
                                },
                                child: Text('새 코스'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () async {
                                  //임시 텍스트
                                  if (token == '') {
                                    await readUserData("docCodeTest123");
                                  } else {
                                    await readUserData(token as String);
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyPage()));
                                },
                                child: Text('내 여행'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () async {
                                  await readPostData();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Community()));
                                },
                                child: Text('커뮤니티'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(100, 100)))
                          ])),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: 400,
                      child: Divider(color: Colors.grey, thickness: 2.0)),
                  Column(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('# 지금, 당신 근처에',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ))),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Image.asset('assets/images/jenu1.jpeg',
                              width: 300, height: 200),
                          Image.asset('assets/images/jeju2.jpeg',
                              width: 300, height: 200)
                        ])),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        width: 400,
                        child: Divider(color: Colors.grey, thickness: 2.0)),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text('# 만연한 가을, 단풍 속으로',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ))),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Image.asset('assets/images/jeju3.jpeg',
                              width: 300, height: 200),
                          Image.asset('assets/images/jeju2.jpeg',
                              width: 300, height: 200)
                        ])),
                  ])
                ]))),
        onWillPop: () async {
          return false;
        });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            print(snapshot);
          if (snapshot.hasData) {

            return buildLogedinScreen();
          }
          else {
            return buildLoginScreen();
          }
        }
    });
  }

  void _selectedDataCalendar_startDay(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 550,
              child: SfDateRangePicker(
                monthViewSettings: DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                ),
                monthFormat: 'MMM',
                showNavigationArrow: true,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(fontSize: 25, color: Colors.black45),
                ),
                headerHeight: 80,
                view: DateRangePickerView.month,
                allowViewNavigation: false,
                backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                initialSelectedDate: DateTime.now(),
                minDate: DateTime.now(),
                // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
                //minDate: tempPickedDate,
                maxDate: DateTime.now().add(new Duration(days: 365)),
                // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
                //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                selectionMode: DateRangePickerSelectionMode.single,
                confirmText: '완료',
                cancelText: '취소',
                onSubmit: (args) => {
                  setState(() {
                    //_endDateController.clear();
                    //tempPickedDate = args as DateTime?;
                    _startDateController.text = args.toString();
                    print(args.toString());

                    startDay = DateTime.parse(args.toString());

                    //convertDateTimeDisplay(_startDateController.text, '가는날');

                    // _endDateController.text = args.toString();
                    //convertDateTimeDisplay(_endDateController.text, '오는날');

                    Navigator.of(context).pop();
                  }),
                },
                onCancel: () => Navigator.of(context).pop(),
                showActionButtons: true,
              ),
            ),
          ));
        });
  }

  void _selectedDataCalendar_endDay(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 550,
              child: SfDateRangePicker(
                monthViewSettings: DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                ),
                monthFormat: 'MMM',
                showNavigationArrow: true,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(fontSize: 25, color: Colors.black45),
                ),
                headerHeight: 80,
                view: DateRangePickerView.month,
                allowViewNavigation: false,
                backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                initialSelectedDate: DateTime.now(),
                minDate: DateTime.now(),
                // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
                //minDate: tempPickedDate,
                maxDate: DateTime.now().add(new Duration(days: 365)),
                // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
                //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                selectionMode: DateRangePickerSelectionMode.single,
                confirmText: '완료',
                cancelText: '취소',
                onSubmit: (args) => {
                  setState(() {
                    //_endDateController.clear();
                    //tempPickedDate = args as DateTime?;
                    //_startDateController.text = args.toString();
                    //print(args.toString());

                    endDay = DateTime.parse(args.toString());
                    endDay = endDay.add(Duration(
                        hours: 23,
                        minutes: 59,
                        milliseconds: 59,
                        microseconds: 59));

                    //convertDateTimeDisplay(_startDateController.text, '가는날');

                    _endDateController.text = args.toString();
                    print(args.toString());

                    //convertDateTimeDisplay(_endDateController.text, '오는날');

                    Navigator.of(context).pop();
                  }),
                },
                onCancel: () => Navigator.of(context).pop(),
                showActionButtons: true,
              ),
            ),
          ));
        });
  }

  String convertDateTimeDisplay(String date, String text) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    if (text == '가는날') {
      //_endDateController.clear();
      return _startDateController.text = serverFormater.format(displayDate);
    } else
      return _endDateController.text = serverFormater.format(displayDate);
  }
}
