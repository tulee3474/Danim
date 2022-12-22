import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _accomodationController = TextEditingController();

  TextEditingController _startTimeController = TextEditingController();

  TextEditingController _endTimeController = TextEditingController();

  TextEditingController searchCourseController = TextEditingController();

  DateTime? tempPickedDate;
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimeController = TextEditingController(text: '시작 시간');
    _endTimeController = TextEditingController(text: '종료 시간');
    searchCourseController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

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

                                  //컨트롤러들 초기화
                                  setState(() {
                                    _startTimeController = TextEditingController(text: '시작 시간');
                                    _endTimeController = TextEditingController(text: '종료 시간');
                                    searchCourseController = TextEditingController();
                                    _startDateController = TextEditingController();
                                    _endDateController = TextEditingController();
                                  });


                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            content: SingleChildScrollView(
                                          child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SizedBox(
                                                    height: 760.0,
                                                    width: 380,
                                                    child: Form(
                                                        key: _form,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              '여행 정보(1/4)',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Column(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text('여행 지역',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                      width:
                                                                          180.0,
                                                                      child:
                                                                          TextFormField(
                                                                        initialValue:
                                                                            "제주도",
                                                                      )),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text('여행 날짜',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            HapticFeedback.mediumImpact();
                                                                            _selectedDataCalendar_startDay(context);
                                                                          },
                                                                          child: AbsorbPointer(
                                                                              child: Container(
                                                                            width:
                                                                                130,
                                                                            //MediaQuery.of(context).size.width,
                                                                            padding: const EdgeInsets.only(
                                                                                right: 10,
                                                                                left: 10,
                                                                                top: 10),
                                                                            child:
                                                                                TextFormField(
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
                                                                          ))),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      SizedBox(
                                                                        width: 105,
                                                                        height: 50,
                                                                        child: TextFormField(
                                                                          controller: _startTimeController,

                                                                          readOnly: true,
                                                                            decoration: InputDecoration(

                                                                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                                                border: const OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                                )),

                                                                            onTap: () =>
                                                                            //FocusScopeNode currentFocus = FocusScope.of(context);

                                                                            showCustomTimePicker(
                                                                            context: context,
                                                                            // It is a must if you provide selectableTimePredicate
                                                                            onFailValidation: (context) => print('Unavailable selection'),
                                                                            initialTime: TimeOfDay(hour: 10, minute: 0),
                                                                            selectableTimePredicate: (time)=>


                                                                            time!.minute == 0).then((time) =>
                                                                            setState(() { dayStartingTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time!.hour);

                                                                              _startTimeController.text = time.format(context);

                                                                            })))
                                                                            /*DateTimeSelectorFormField(
                                                                          controller:
                                                                              _startTimeController,
                                                                          decoration: AppConstants.inputDecoration.copyWith(
                                                                              labelText: "시작 시간",
                                                                              labelStyle: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value == "")
                                                                              return "Please select start time.";

                                                                            return null;
                                                                          },

                                                                          onSave: (date) =>
                                                                              dayStartingTime = date,
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.black,
                                                                            fontSize:
                                                                                17.0,
                                                                          ),
                                                                          type:
                                                                              DateTimeSelectionType.time,
                                                                        )*/
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            HapticFeedback.mediumImpact();
                                                                            _selectedDataCalendar_endDay(context);
                                                                          },
                                                                          child: AbsorbPointer(
                                                                              child: Container(
                                                                            width:
                                                                                130,
                                                                            padding: const EdgeInsets.only(
                                                                                right: 10,
                                                                                left: 10,
                                                                                top: 10),
                                                                            child:
                                                                                TextFormField(
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
                                                                          ))),
                                                                      SizedBox(
                                                                          width:
                                                                              5),

                                                                      SizedBox(
                                                                          width: 105,
                                                                          height: 50,
                                                                          child: TextFormField(
                                                                              controller: _endTimeController,

                                                                              readOnly: true,
                                                                              decoration: InputDecoration(

                                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                                                  border: const OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                                  )),

                                                                              onTap: () =>
                                                                              //FocusScopeNode currentFocus = FocusScope.of(context);

                                                                              showCustomTimePicker(
                                                                                  context: context,
                                                                                  // It is a must if you provide selectableTimePredicate
                                                                                  onFailValidation: (context) => print('Unavailable selection'),
                                                                                  initialTime: TimeOfDay(hour: 20, minute: 0),
                                                                                  selectableTimePredicate: (time)=>

                                                                                  time!.minute == 0).then((time) =>
                                                                                  setState(() { dayEndingTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time!.hour);

                                                                                  _endTimeController.text = time.format(context);

                                                                                  })))
                                                                        /*DateTimeSelectorFormField(
                                                                          controller:
                                                                              _startTimeController,
                                                                          decoration: AppConstants.inputDecoration.copyWith(
                                                                              labelText: "시작 시간",
                                                                              labelStyle: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value == "")
                                                                              return "Please select start time.";

                                                                            return null;
                                                                          },

                                                                          onSave: (date) =>
                                                                              dayStartingTime = date,
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.black,
                                                                            fontSize:
                                                                                17.0,
                                                                          ),
                                                                          type:
                                                                              DateTimeSelectionType.time,
                                                                        )*/
                                                                      )

                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          30),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text('여행 숙소',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                    '미리 정해놓은 숙소가 있다면 입력해주세요',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        var place =
                                                                            await PlacesAutocomplete.show(
                                                                          context:
                                                                              context,
                                                                          apiKey:
                                                                              'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                          mode:
                                                                              Mode.overlay,
                                                                          language:
                                                                              "kr",
                                                                          //types: [],
                                                                          //strictbounds: false,
                                                                          components: [
                                                                            Component(Component.country,
                                                                                'kr')
                                                                          ],
                                                                          //google_map_webservice package
                                                                          //onError: (err){
                                                                          //  print(err);
                                                                          //},
                                                                        );

                                                                        if (place !=
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            location =
                                                                                place.description.toString();
                                                                          });

                                                                          //form google_maps_webservice package
                                                                          final plist =
                                                                              GoogleMapsPlaces(
                                                                            apiKey:
                                                                                'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                                                                            apiHeaders:
                                                                                await GoogleApiHeaders().getHeaders(),
                                                                            //from google_api_headers package
                                                                          );

                                                                          String
                                                                              placeid =
                                                                              place.placeId ?? "0";

                                                                          final detail =
                                                                              await plist.getDetailsByPlaceId(placeid);
                                                                          final geometry = detail
                                                                              .result
                                                                              .geometry!;
                                                                          final lat = geometry
                                                                              .location
                                                                              .lat;
                                                                          final lang = geometry
                                                                              .location
                                                                              .lng;
                                                                          var newlatlang = LatLng(
                                                                              lat,
                                                                              lang);
                                                                          accommodationLatLen
                                                                              .add(newlatlang);

                                                                          //move map camera to selected place with animation
                                                                          //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                                                          var places =
                                                                              location.split(', ');
                                                                          String
                                                                              placeName =
                                                                              places[places.length - 1];
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
                                                                              selectedList[0],
                                                                              selectedList[1],
                                                                              selectedList[2],
                                                                              selectedList[3],
                                                                              selectedList[4]));
                                                                          setState(
                                                                              () {});
                                                                          setState(
                                                                              () {});
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            location =
                                                                                "숙소를 검색하세요.";
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(15),
                                                                        child:
                                                                            Card(
                                                                          child: Container(
                                                                              padding: EdgeInsets.all(0),
                                                                              width: MediaQuery.of(context).size.width - 40,
                                                                              child: ListTile(
                                                                                title: Text(
                                                                                  location,
                                                                                  style: TextStyle(fontSize: 18),
                                                                                ),
                                                                                trailing: Icon(Icons.search),
                                                                                dense: true,
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    height: 80,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            width: 120.0,
                                                                            height: 50.0,
                                                                            // padding: EdgeInsets
                                                                            //     .fromLTRB(0, 30,
                                                                            //         0, 0),
                                                                            child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  //인풋값들 출력 확인
                                                                                  //숙소값, 가는날, 오는만 있어야 정상.
                                                                                  setState(() {
                                                                                    markers.clear();
                                                                                    pathOverlays.clear();
                                                                                    location = '숙소를 검색하세요.';
                                                                                  });

                                                                                  _form.currentState?.save();

                                                                                  print("accomodation : ${accomodation}");
                                                                                  print("accomo latitude: $accomodation_lati");
                                                                                  print("accomo longitude: $accomodation_long");
                                                                                  print("selectedList : ${selectedList}");
                                                                                  print("fixTourSpotList: ${fixTourSpotList}");
                                                                                  print("fixDateList : ${fixDateList}");
                                                                                  print("startDay : $startDay");
                                                                                  print("endDay: $endDay");
                                                                                  print("dayStartingTime: $dayStartingTime");

                                                                                  print("dayEndingTime: $dayEndingTime");

                                                                                  print("며칠? ${endDay.difference(startDay).inDays + 1}");

                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetail()));
                                                                                },
                                                                                child: Text(
                                                                                  '추천코스',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Neo"),
                                                                                ))),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            width: 120.0,
                                                                            height: 50.0,
                                                                            child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    markers.clear();
                                                                                    pathOverlays.clear();
                                                                                    location = '숙소를 검색하세요.';
                                                                                  });
                                                                                  List<List<Place>> emptyPreset = [
                                                                                    for (int i = 0; i < endDay.difference(startDay).inDays + 1; i++) [],
                                                                                  ];

                                                                                  List<List<int>> emptyMovingTime = [
                                                                                    for (int i = 0; i < endDay.difference(startDay).inDays + 1; i++) []
                                                                                  ];

                                                                                  List<List<String>> emptyMovingSteps = [
                                                                                    for (int i = 0; i < endDay.difference(startDay).inDays + 1; i++) []
                                                                                  ];

                                                                                  course_selected = emptyPreset;

                                                                                  print(emptyPreset);
                                                                                  print("startDay : $startDay");
                                                                                  print("endDay: $endDay");
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => LoadingTimeTable(
                                                                                                emptyPreset,
                                                                                                0, //혼자짤래요 기본값 자차 이동

                                                                                          dayStartingTime.hour,
                                                                                           dayEndingTime.hour
                                                                                              )));
                                                                                },
                                                                                child: Text('혼자 짤래요', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Neo")))),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ],
                                                        ))),
                                              )),
                                        ));
                                      });
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
                            child:
                            Row(children: [
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
                              Image.asset('assets/images/10.jpg',
                                  width: 300, height: 200),
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
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
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
                enablePastDates: false,
                //minDate: DateTime.now(),
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
                enablePastDates: false,
                minDate: startDay,
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
                //minDate: DateTime.now(),
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
