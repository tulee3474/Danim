import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:danim/src/courseDetail.dart';
import 'package:danim/src/myPage.dart';
import 'package:danim/src/start_end_day.dart';

import 'package:danim/src/login.dart';

import 'community.dart';

void main() {
  runApp(MaterialApp(
    title: 'DANIM',
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  DateTime? tempPickedDate;

  @override
  Widget build(BuildContext context) {
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
                  accountName: Text('yeonuuu'),
                  accountEmail: Text('dysqkddnf@gmail.com')),
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
            body: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: EdgeInsets.all(20),
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: SizedBox(
                                      height: 350.0,
                                      width: 300,
                                      child: Column(children: <Widget>[
                                        Column(children: <Widget>[
                                          Container(
                                              width: 180.0,
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: '지역'))),
                                          Container(
                                            width: 180.0,
                                            child: SafeArea(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10)),
                                                    GestureDetector(
                                                        onTap: () {
                                                          HapticFeedback
                                                              .mediumImpact();
                                                          _selectedDataCalendar_startDay(
                                                              context);
                                                        },
                                                        child: AbsorbPointer(
                                                            child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  left: 10,
                                                                  top: 10),
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  new EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              isDense: true,
                                                              hintText: "가는 날",
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .red),
                                                              ),
                                                            ),
                                                            controller:
                                                                _startDateController,
                                                          ),
                                                        )))
                                                  ]),
                                            )),
                                          ),

                                          Container(
                                            width: 180.0,
                                            child: SafeArea(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10)),
                                                    GestureDetector(
                                                        onTap: () {
                                                          HapticFeedback
                                                              .mediumImpact();
                                                          _selectedDataCalendar_endDay(
                                                              context);
                                                        },
                                                        child: AbsorbPointer(
                                                            child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  left: 10,
                                                                  top: 10),
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  new EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              isDense: true,
                                                              hintText: "오는 날",
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .red),
                                                              ),
                                                            ),
                                                            controller:
                                                                _endDateController,
                                                          ),
                                                        )))
                                                  ]),
                                            )),
                                          ),

                                          ////
                                        ]),
                                        Container(
                                            width: 100.0,
                                            padding: EdgeInsets.fromLTRB(
                                                0, 30, 0, 0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CourseDetail()));
                                                },
                                                child: Text('추천코스'))),
                                        Container(
                                            width: 100.0,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  print('customize course');
                                                },
                                                child: Text('혼자 짤래요')))
                                      ]),
                                    ));
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
                              //이태운 수정한 부분
                              String docCode = "docCodeTest123";
                              await readUserData(docCode);
                              //이태운 수정한 부분
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
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Community()))
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
            ])),
        onWillPop: () async {
          return false;
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
