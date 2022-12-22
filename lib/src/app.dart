import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danim/src/dayTimeFix.dart';
import 'package:danim/src/global_house_check.dart';
import 'package:danim/src/loadingMyPage.dart';
import 'package:danim/src/loadingOtherCourse.dart';
import 'package:danim/src/loadingTimeTable.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:danim/src/login.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../map.dart';
import '../route_ai.dart';
import '../widgets/date_time_selector.dart';
import 'accomodationInfo.dart';
import 'community.dart';
import 'courseSelected.dart';
import 'date_selectlist.dart';
import 'fixInfo.dart';
import 'package:danim/firebase_read_write.dart';
import '../temp.dart';

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

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController searchCourseController = TextEditingController();

  DateTime? tempPickedDate;
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCourseController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color.fromRGBO(194, 233, 252, 1),
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light),
              title: Transform(
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image.asset(IconsPath.logo,
                      fit: BoxFit.contain, height: 40) // height 60->40
                ]),
              ),
            ),
            endDrawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
              UserAccountsDrawerHeader(
                  arrowColor: Color.fromARGB(255, 78, 194, 252),
                  accountName: Text('$userName'),
                  accountEmail: Text('$userEmail')),
              ListTile(
                  leading: Icon(Icons.search, color: Colors.grey),
                  title: Text("코스 검색"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: SizedBox(
                                  width: 200,
                                  height: 300,
                                  child: Center(
                                      child: Column(children: [
                                    Container(
                                        margin: EdgeInsets.all(10),
                                        child: TextField(
                                            controller: searchCourseController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: '코스 코드',
                                            ))),
                                    Container(
                                        width: 120.0,
                                        height: 80.0,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 30, 0, 0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoadingOtherCourse(
                                                              searchCourseController
                                                                  .text)));
                                            },
                                            child: Text("검색하기",
                                                style: TextStyle(
                                                  fontFamily: "Neo",
                                                  fontWeight: FontWeight.bold,
                                                ))))
                                  ]))));
                        });
                  }),
              ListTile(
                  leading: Icon(Icons.login, color: Colors.grey),
                  title: Text('로그아웃'),
                  onTap: () => {
                        //로그아웃
                        FirebaseAuth.instance.signOut(),
                        googleSignIn.signOut(),
                        //Login()
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()))
                      }),
            ])),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                  globalHouseCheck = false;

                                  //selectedList 초기화
                                  selectedList = [
                                    [0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0]
                                  ];

                                  //픽스 관광지 정보 초기화
                                  fixTourSpotList = [];
                                  fixDateList = [];

                                  //가는 날, 오는 날 초기화
                                  startDay = DateTime.now();
                                  endDay = DateTime.now();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DayTimeFix()));
                                },
                                child: Text(
                                  '새 코스',
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 78, 194, 252),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 215, 240, 253),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          width: 2.0,
                                          color: Color.fromARGB(
                                              255, 78, 194, 252)),
                                    ),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () {
                                  //임시 텍스트
                                  // if (token == '') {
                                  //   await readUserData("docCodeTest123");
                                  // } else {
                                  //   await readUserData(token as String);
                                  // }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoadingMyPage()));
                                },
                                child: Text(
                                  '내 여행',
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 78, 194, 252),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 215, 240, 253),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(
                                        width: 2.0,
                                        color:
                                            Color.fromARGB(255, 78, 194, 252)),
                                    minimumSize: Size(100, 100))),
                            ElevatedButton(
                                onPressed: () async {
                                  await readPostData();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Community()));
                                },
                                child: Text(
                                  '커뮤니티',
                                  style: TextStyle(
                                    fontFamily: "Neo",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 78, 194, 252),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 215, 240, 253),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(
                                        width: 2.0,
                                        color:
                                            Color.fromARGB(255, 78, 194, 252)),
                                    minimumSize: Size(100, 100)))
                          ])),
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('추운겨울에는 실내여행지',
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Neo",
                                    )),
                                SizedBox(height: 3),
                                Text('#커플여행 #우정여행 #문화시설 #실내여행지',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 10.0,
                                      fontFamily: "Neo",
                                    )),
                              ],
                            )),
                        SizedBox(width: 0, height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Image.asset('assets/images/1.png',
                                  width: 300, height: 200),
                              Image.asset('assets/images/2.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/3.jpg',
                                  width: 300, height: 200)
                            ])),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          height: 7,
                          decoration: BoxDecoration(
                            color: Color(0xffF4F4F4),
                            border: Border(
                              top: BorderSide(
                                  width: 1.0, color: Color(0xffD4D4D4)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('연인과 함께 동백꽃 속으로',
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Neo",
                                  )),
                              SizedBox(height: 3),
                              Text('#커플여행 #힐링 #사진 #산책',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 2.0,
                                    fontSize: 10.0,
                                    fontFamily: "Neo",
                                  )),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoadingOtherCourse(
                                              "JsiuTQPLkGTeL8QEURHJ5bPj10i1/1")));
                            }, child: Image.asset('assets/images/rightarrow.png')),

                            ],
                          ),
                        ),
                        SizedBox(width: 0, height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Image.asset('assets/images/4.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/5.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/6.jpg',
                                  width: 300, height: 200)
                            ])),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          height: 7,
                          decoration: BoxDecoration(
                            color: Color(0xffF4F4F4),
                            border: Border(
                              top: BorderSide(
                                  width: 1.0, color: Color(0xffD4D4D4)),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('제주도의 이색체험',
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Neo",
                                    )),
                                SizedBox(height: 3),
                                Text('#이색체험',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 10.0,
                                      fontFamily: "Neo",
                                    )),
                              ],
                            )),
                        SizedBox(width: 0, height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Image.asset('assets/images/7.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/8.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/9.jpg',
                                  width: 300, height: 200)
                            ])),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          height: 7,
                          decoration: BoxDecoration(
                            color: Color(0xffF4F4F4),
                            border: Border(
                              top: BorderSide(
                                  width: 1.0, color: Color(0xffD4D4D4)),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('이국적인 제주도',
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Neo",
                                    )),
                                SizedBox(height: 3),
                                Text('#이색체험',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 10.0,
                                      fontFamily: "Neo",
                                    )),
                              ],
                            )),
                        SizedBox(width: 0, height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Image.asset('assets/images/10.png',
                                  width: 310, height: 250),
                              Image.asset('assets/images/10.png',
                                  width: 310, height: 250),
                              Image.asset('assets/images/10.png',
                                  width: 310, height: 250),
                              Image.asset('assets/images/11.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/12.jpg',
                                  width: 300, height: 200)
                            ])),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          height: 7,
                          decoration: BoxDecoration(
                            color: Color(0xffF4F4F4),
                            border: Border(
                              top: BorderSide(
                                  width: 1.0, color: Color(0xffD4D4D4)),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('아이와 함께 신나는 액티비티',
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Neo",
                                    )),
                                SizedBox(height: 3),
                                Text('#액티비티',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 10.0,
                                      fontFamily: "Neo",
                                    )),
                              ],
                            )),
                        SizedBox(width: 0, height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Image.asset('assets/images/13.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/14.jpg',
                                  width: 300, height: 200),
                              Image.asset('assets/images/15.jpg',
                                  width: 300, height: 200)
                            ])),
                      ])
                ]))),
      ),
    );
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }
}
