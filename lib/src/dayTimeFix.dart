import 'package:danim/src/courseDetail.dart';
import 'package:danim/src/courseSelected.dart';
import 'package:danim/src/date_selectlist.dart';
import 'package:danim/src/fixInfo.dart';
import 'package:danim/src/loadingTimeTable.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:danim/widgets/date_time_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../components/image_data.dart';
import '../map.dart';
import '../route_ai.dart';
import 'loading.dart';
import 'accomodationInfo.dart';

class DayTimeFix extends StatefulWidget {
  @override
  State<DayTimeFix> createState() => _DayTimeFixState();

  DayTimeFix();
}

class _DayTimeFixState extends State<DayTimeFix> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _accomodationController = TextEditingController();

  TextEditingController _startTimeController = TextEditingController();

  TextEditingController _endTimeController = TextEditingController();

  TextEditingController searchCourseController = TextEditingController();

  DateTime? tempPickedDate;
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  void init() {
    super.initState();
    _startTimeController = TextEditingController(text: '시작 시간');
    _endTimeController = TextEditingController(text: '종료 시간');
    searchCourseController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
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
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
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
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(message,
                                style: TextStyle(
                                  fontFamily: "Neo",
                                  fontWeight: FontWeight.bold,
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
        title: Center(
            child: Text('여행 일정 정보(1/4)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Hi!',
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              //첫화면까지 팝해버리는거임
            },
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Text('여행 지역 : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Neo",
                                letterSpacing: 2.0,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Container(
                          width: 100.0,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            initialValue: "제주도",
                            style: TextStyle(
                              color: Color.fromARGB(255, 83, 83, 83),
                              fontSize: 17.0,
                              //fontFamily: "Neo",
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('여행 날짜 & 시간',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Neo",
                        letterSpacing: 2.0,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Text(
                  '시간은, 기본값으로 가는 날 10시부터 오는 날 8시로 설정됩니다.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _selectedDataCalendar_startDay(context);
                            },
                            child: AbsorbPointer(
                                child: Container(
                              width: 130,
                              //MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              child: TextFormField(
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  isDense: true,
                                  hintText: "가는 날",
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    fontSize: 17.0,
                                    //fontFamily: "Neo",
                                  ),
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
                        SizedBox(width: 5),
                        SizedBox(
                            width: 115,
                            height: 50,
                            child: TextFormField(
                                controller: _startTimeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    )),
                                onTap: () =>
                                    //FocusScopeNode currentFocus = FocusScope.of(context);

                                    showCustomTimePicker(
                                        context: context,
                                        // It is a must if you provide selectableTimePredicate
                                        onFailValidation: (context) =>
                                            print('Unavailable selection'),
                                        initialTime:
                                            TimeOfDay(hour: 10, minute: 0),
                                        selectableTimePredicate: (time) =>
                                            time!.minute == 0).then(
                                        (time) => setState(() {
                                              dayStartingTime = DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                  time!.hour);

                                              _startTimeController.text =
                                                  time.format(context);
                                            })))),
                      ]),
                ),
                SizedBox(height: 10),
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _selectedDataCalendar_endDay(context);
                            },
                            child: AbsorbPointer(
                                child: Container(
                              width: 130,
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              child: TextFormField(
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  isDense: true,
                                  hintText: "오는 날",
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    fontSize: 17.0,
                                    //fontFamily: "Neo",
                                  ),
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
                        SizedBox(width: 5),
                        SizedBox(
                            width: 115,
                            height: 50,
                            child: TextFormField(
                                controller: _endTimeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    )),
                                onTap: () =>
                                    //FocusScopeNode currentFocus = FocusScope.of(context);

                                    showCustomTimePicker(
                                        context: context,
                                        // It is a must if you provide selectableTimePredicate
                                        onFailValidation: (context) =>
                                            print('Unavailable selection'),
                                        initialTime:
                                            TimeOfDay(hour: 20, minute: 0),
                                        selectableTimePredicate: (time) =>
                                            time!.minute == 0).then(
                                        (time) => setState(() {
                                              dayEndingTime = DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day,
                                                  time!.hour);

                                              _endTimeController.text =
                                                  time.format(context);
                                            })))),
                      ]),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('여행 숙소',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Neo",
                        letterSpacing: 2.0,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Text(
                  '미리 정해놓은 숙소가 있다면 입력해주세요.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
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
                          location = place.description.toString();
                        });

                        //form google_maps_webservice package
                        final plist = GoogleMapsPlaces(
                          apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                          //from google_api_headers package
                        );

                        String placeid = place.placeId ?? "0";

                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;
                        var newlatlang = LatLng(lat, lang);
                        accommodationLatLen.add(newlatlang);

                        //move map camera to selected place with animation
                        //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                        var places = location.split(', ');
                        String placeName = places[places.length - 1];
                        print('placeName: $placeName');

                        //숙소 정보 업데이트
                        accomodation = placeName;
                        accomodation_lati = lat;
                        accomodation_long = lang;

                        //관광지 이름
                        var fixTourSpotName = placeName;

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
                          location = "숙소를 검색하세요.";
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: 120.0,
                            height: 60.0,
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

                                  print(
                                      "며칠? ${endDay.difference(startDay).inDays + 1}");

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CourseDetail()));
                                },
                                child: Text(
                                  '추천코스',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Neo"),
                                ))),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                            width: 120.0,
                            height: 60.0,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    markers.clear();
                                    pathOverlays.clear();
                                    location = '숙소를 검색하세요.';
                                  });
                                  List<List<Place>> emptyPreset = [
                                    for (int i = 0;
                                        i <
                                            endDay.difference(startDay).inDays +
                                                1;
                                        i++)
                                      [],
                                  ];

                                  List<List<int>> emptyMovingTime = [
                                    for (int i = 0;
                                        i <
                                            endDay.difference(startDay).inDays +
                                                1;
                                        i++)
                                      []
                                  ];

                                  List<List<String>> emptyMovingSteps = [
                                    for (int i = 0;
                                        i <
                                            endDay.difference(startDay).inDays +
                                                1;
                                        i++)
                                      []
                                  ];

                                  course_selected = emptyPreset;

                                  print(emptyPreset);
                                  print("startDay : $startDay");
                                  print("endDay: $endDay");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoadingTimeTable(
                                                  emptyPreset,
                                                  0, //혼자짤래요 기본값 자차 이동

                                                  dayStartingTime.hour,
                                                  dayEndingTime.hour)));
                                },
                                child: Text('혼자 짤래요',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Neo")))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
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
