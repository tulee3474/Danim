import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:danim/calendar_view.dart';
import 'package:danim/src/event_CalendarEventData_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/model/event.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'package:danim/src/place.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:danim/src/preset.dart';
import '../../map.dart' as map;

import '../map.dart';
import '../route_ai.dart';
import '../tourinfo.dart';
import '../widgets/custom_button.dart';
import '../widgets/date_time_selector.dart';
import 'createMovingTimeList.dart';
import 'date_selectlist.dart';
import 'foodRecommend.dart';
import 'package:danim/route.dart';
import 'package:danim/nearby.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/login.dart';
import 'package:danim/src/user.dart';

/*

// 자차 이동시간 리스트 생성
Future<List<List<int>>> createDrivingTimeList (List<List<Place>> preset) async {

  List<List<int>> drivingTimeList = [
    for(int i=0; i<preset.length; i++)
      []
  ];
  int movingTime = 0;

  //자차 이동시간 받아오기

    for (int i = 0; i < preset.length; i++) {
      for (int j = 0; j < preset[i].length - 1; j++) {
        movingTime = (await getDrivingDuration(
            preset[i][j].latitude, preset[i][j].longitude,
            preset[i][j + 1].latitude, preset[i][j + 1].longitude));
        drivingTimeList[i].add(movingTime);
      }
    }


  return await drivingTimeList;
}

//대중교통 이동시간 리스트 생성
Future<List<List<TransitTime>>> createTransitTimeList( List<List<Place>> preset ) async {

  TransitTime transitTime;
  List<List<TransitTime>> transitTimeList = [
    for(int i=0; i<preset.length; i++)
      []
  ];

  for(int i=0; i<preset.length; i++){

    for(int j=0; j<preset[i].length-1; j++){

      transitTime = (await getTransitDuration(preset[i][j].latitude, preset[i][j].longitude,
      preset[i][j + 1].latitude, preset[i][j + 1].longitude));

    }

  }


  return transitTimeList;

}

*/

List<CalendarEventData<Event>> createEventList(List<List<Place>> preset,
    DateTime startDay, DateTime endDay, List<List<int>> moving_time) {
  int startDayTime = 7;
  int endDayTime = 21;

  bool lunch = false;
  bool dinner = false;

  //int timeIndex = startDayTime;
  DateTime timeIndex = DateTime(startDay.year, startDay.month, startDay.day,
      startDayTime, 0); //처음 타임인덱스 값
  int minuteIndex = 0;
  DateTime dayIndex = startDay;
  //int moving_time = 0;

  List<CalendarEventData<Event>> events = [];

  List<List<int>> drivingTimeList = [
    for (int i = 0; i < preset.length; i++) []
  ];

  List<List<TransitTime>> transitTimeList = [
    for (int i = 0; i < preset.length; i++) []
  ];

  for (int i = 0; i < preset.length; i++) {
    for (int j = 0; j < preset[i].length; j++) {
      if (timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 11, 0)) >=
              0 &&
          timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 14, 0)) <
              0 &&
          !lunch) {
        lunch = true;

        DateTime mealEndTime = DateTime(dayIndex.year, dayIndex.month,
                dayIndex.day, timeIndex.hour, timeIndex.minute)
            .add(Duration(hours: 1));

        events.add(CalendarEventData(
            title: '식사시간',
            date: dayIndex,
            event: Event(title: '식사시간'),
            description: '',
            startTime: DateTime(
              dayIndex.year,
              dayIndex.month,
              dayIndex.day,
              timeIndex.hour,
              timeIndex.minute,
            ),
            endTime: mealEndTime,
            color: Colors.orangeAccent));

        timeIndex = mealEndTime;

        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + 30);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '이동',
            date: dayIndex,
            event: Event(title: '이동'),
            description: '',
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTime,
            color: Colors.grey));

        timeIndex = transitEndTime;
      }

      if (timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 17, 0)) >=
              0 &&
          timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 20, 0)) <
              0 &&
          !dinner) {
        dinner = true;

        DateTime mealEndTime = DateTime(dayIndex.year, dayIndex.month,
                dayIndex.day, timeIndex.hour, timeIndex.minute)
            .add(Duration(hours: 1));

        events.add(CalendarEventData(
            title: '식사시간',
            date: dayIndex,
            event: Event(title: '식사시간'),
            description: '',
            startTime: DateTime(
              dayIndex.year,
              dayIndex.month,
              dayIndex.day,
              timeIndex.hour,
              timeIndex.minute,
            ),
            endTime: mealEndTime,
            color: Colors.orangeAccent));

        timeIndex = mealEndTime;

        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + 30);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '이동',
            date: dayIndex,
            event: Event(title: '이동'),
            description: '',
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTime,
            color: Colors.grey));

        timeIndex = transitEndTime;
      }

      if (timeIndex.compareTo(DateTime(
              dayIndex.year, dayIndex.month, dayIndex.day, endDayTime)) >
          0) {
        break;
      }

      DateTime tourEndTime = DateTime(
          dayIndex.year,
          dayIndex.month,
          dayIndex.day,
          timeIndex.hour,
          timeIndex.minute + preset[i][j].takenTime);
      DateTime tourEndTimeUpdated = tourEndTime;

      events
        ..add(CalendarEventData(
            title: '${preset[i][j].name}',
            date: dayIndex,
            event: Event(title: '${preset[i][j].name}'),
            description: '',
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: tourEndTimeUpdated));

      timeIndex = tourEndTimeUpdated;

      if (timeIndex.compareTo(DateTime(dayIndex.year, dayIndex.month,
              dayIndex.day, timeIndex.hour, timeIndex.minute)) >
          0) {
        break;
      }

      if (j < preset[i].length - 1) {
        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + moving_time[i][j]);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '이동',
            date: dayIndex,
            event: Event(title: '이동'),
            description: '',
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTimeUpdated,
            color: Colors.grey));

        timeIndex = transitEndTimeUpdated;
      }
    }

    dayIndex = dayIndex.add(Duration(days: 1));
    timeIndex =
        DateTime(dayIndex.year, dayIndex.month, dayIndex.day, startDayTime, 0);

    lunch = false;
    dinner = false;
  }

  return events;
}

//mealTimeList 생성

List<DateTime> createMealTimeList(List<CalendarEventData<Event>> events) {
  List<DateTime> mealTimeList = [];

  for (int i = 0; i < events.length; i++) {
    if (events[i].title == '식사시간') {
      mealTimeList.add(events[i].startTime);
    }
  }

  return mealTimeList;
}

//식사시간 앞 뒤 관광지 위도 경도 저장 배열

List<List<double>> createNearMealLocationList(
    List<CalendarEventData<Event>> events, List<List<Place>> preset) {
  List<List<double>> nearMealLocationList = [[], []]; // 위도, 경도
  List<String> nearMealName = [];

  for (int i = 2; i < events.length - 1; i++) {
    //타이틀 가져옴
    if (events[i].title == "식사시간") {
      nearMealName.add(events[i - 2].title);
      nearMealName.add(events[i + 2].title);

      print('nearMealName : $nearMealName');
    }

    //타이틀 비교해서 위도 경도 만들기

    //여기 고쳐야됨 .....

    for (int m = 0; m < nearMealName.length; m++) {
      for (int i = 0; i < preset.length; i++) {
        for (int j = 0; j < preset[i].length; j++) {
          if (nearMealName[m] == preset[i][j].name) {
            nearMealLocationList[0].add(preset[i][j].latitude);
            nearMealLocationList[1].add(preset[i][j].longitude);

            break;
          }
        }
      }
    }

    //print('nearMealLocations : $nearMealLocationList');

  }

  return nearMealLocationList;
}

class Timetable extends StatefulWidget {
  Timetable(
      {Key? key,
      required this.preset,
      required this.transit,
      required this.movingTimeList})
      : super(key: key);

  int transit = 0; // 자차:0, 대중교통:1

  List<List<Place>> preset = [];
  DateTime currentDate = startDay;
  List<List<int>> movingTimeList;

  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final _CourseNameController = TextEditingController();

  late List<CalendarEventData<Event>> events =
      createEventList(widget.preset, startDay, endDay, widget.movingTimeList);
  late List<DateTime> mealTimes = createMealTimeList(events);
  late List<List<double>> nearMealLocationList =
      createNearMealLocationList(events, widget.preset);

  String isSaved = '';

  @override
  void initState() {
    super.initState();
    //events = await createEventList(widget.preset, startDay, endDay, widget.transit);
  }

  @override
  void dispose() {
    _CourseNameController.dispose();
    super.dispose();
  }

  List<DateTime> getMealTimeList() {
    return mealTimes;
  }

  List<List<double>> getNearMealLocation() {
    return nearMealLocationList;
  }

  int getTransit() {
    return widget.transit;
  }

  List<List<Place>> getPreset() {
    return widget.preset;
  }

  List<CalendarEventData<Event>> getEvents() {
    return events;
  }

  List<List<int>> getMovingTimeList() {
    return widget.movingTimeList;
  }

  void deletePlace(Place place) {
    setState(() {
      widget.preset.remove(place);
    });
  }

  void setEventList() {
    events =
        createEventList(widget.preset, startDay, endDay, widget.movingTimeList)
            as List<CalendarEventData<Event>>;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
        controller: EventController<Event>()..addAll(events),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(IconsPath.back,
                        fit: BoxFit.contain, height: 20)),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: Column(children: [
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 30, 0, 0),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              //List<CalendarEventData<Event>> 에서 List<CalendarEventData> 로 변환 !!
                                              List<CalendarEventData>
                                                  eventsForDB = [];
                                              eventsForDB =
                                                  eventsToCalendarEventData(
                                                      events);

                                              //여기서 DB 연결 !!!
                                              // 현재 events 저장
                                              //print('$eventsForDB');결

                                              //임시 토큰!
                                              if (token == '') {
                                                //int 최대치는 약 21억
                                                token = (Random().nextInt(
                                                            2100000000) +
                                                        1)
                                                    .toString();
                                              }
                                              print(token);
                                              print(token as String);

                                              ReadController read =
                                                  ReadController();
                                              User userData;
                                              try {
                                                userData = await read
                                                    .fb_read_user(token);
                                              } catch (e) {
                                                print(token);
                                                print(token as String);
                                                userData = User(
                                                  token as String,
                                                  token as String,
                                                  [],
                                                  [],
                                                  [],
                                                  [],
                                                  [],
                                                  [],
                                                );
                                              }
                                              print(userData.docCode);

                                              userData.travelList
                                                  .add("제주도"); //임시 city 고정
                                              //1일차, 2일차 수만큼 반복
                                              int placeSum = 0;
                                              List<String> placeLi = [];
                                              for (int p = 0;
                                                  p < getPreset().length;
                                                  p++) {
                                                placeSum +=
                                                    getPreset()[p].length;
                                                for (int q = 0;
                                                    q < getPreset()[p].length;
                                                    q++) {
                                                  placeLi.add(
                                                      getPreset()[p][q].name);
                                                }
                                              }
                                              userData.placeNumList
                                                  .add(placeSum);
                                              userData.traveledPlaceList =
                                                  List.from(userData
                                                      .traveledPlaceList)
                                                    ..addAll(placeLi);
                                              userData.eventNumList
                                                  .add(eventsForDB.length);
                                              userData.eventList =
                                                  List.from(userData.eventList)
                                                    ..addAll(eventsForDB);
                                              userData.diaryList.add("");
                                              fb_write_user(
                                                  userData.docCode,
                                                  userData.name,
                                                  userData.travelList,
                                                  userData.placeNumList,
                                                  userData.traveledPlaceList,
                                                  userData.eventNumList,
                                                  selectedList, //전역변수라서, 차후에 문제생길수도
                                                  userData.eventList,
                                                  userData.diaryList);

                                              print('pathlist saved');

                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        content: SizedBox(
                                                            width: 150,
                                                            height: 50,
                                                            child: Container(
                                                                child: Text('Saved as : ' +
                                                                    userData
                                                                        .docCode
                                                                        .toString()))));
                                                  });
                                            },
                                            child: Text("코스 저장")))
                                  ])),
                            );
                          });
                    },
                    child: Icon(Icons.save))
              ]),
            ),
            floatingActionButton: Stack(children: [
              Align(
                  alignment: Alignment(
                      Alignment.bottomRight.x, Alignment.bottomRight.y - 0.15),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    elevation: 8,
                    onPressed: () async {
                      final event = await context
                          .pushRoute<CalendarEventData<Event>>(CreateEventPage(
                        getPreset: getPreset,
                        transit: widget.transit,
                        getEvents: getEvents,
                        currentDate: widget.currentDate,
                        getMovingTimeList: getMovingTimeList,
                        withDuration: true,
                      ));
                      if (event == null) return;
                      CalendarControllerProvider.of<Event>(context)
                          .controller
                          .add(event);
                    },
                  )),
            ]),
            body: DayViewWidget(
              transit: widget.transit,
              getPreset: getPreset,
              getEvents: getEvents,
              getMovingTimeList: getMovingTimeList,
              getMealTimes: getMealTimeList,
              getNearMealLocations: getNearMealLocation,
            )));
  }
}

class DayViewWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  final Function() getPreset;
  final Function() getEvents;
  final Function() getMovingTimeList;
  final Function() getMealTimes;
  final Function() getNearMealLocations;
  int transit = 0;

  DayViewWidget(
      {Key? key,
      this.state,
      this.width,
      required this.transit,
      required this.getPreset,
      required this.getEvents,
      required this.getMovingTimeList,
      required this.getMealTimes,
      required this.getNearMealLocations})
      : super(key: key);

  @override
  _DayViewWidgetState createState() => _DayViewWidgetState();
}

class _DayViewWidgetState extends State<DayViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DayView<Event>(
      minDay: startDay,
      maxDay: endDay,
      key: widget.state,
      width: widget.width,
      onEventTap: (event, date) async {
        if (event[0].title == '식사시간') {
          List<DateTime> mealTimes = widget.getMealTimes();
          List<List<double>> nearMealLocations = widget.getNearMealLocations();

          print(mealTimes);
          print(nearMealLocations);
          print(nearMealLocations[0].length);
          print(nearMealLocations[1].length);

          int mealNum = 0;

          for (int i = 0; i < mealTimes.length; i++) {
            if (mealTimes[i].compareTo(event[0].startTime) == 0) {
              mealNum = i;
            }
          }

          double lat1 = nearMealLocations[0][mealNum * 2];
          double lat2 = nearMealLocations[0][mealNum * 2 + 1];
          double lon1 = nearMealLocations[1][mealNum * 2];
          double lon2 = nearMealLocations[1][mealNum * 2 + 1];

          print(lat1);
          print(lon1);
          print(lat2);
          print(lon2);

          List<Restaurant> restList =
              await getRestaurant(lat1, lon1, lat2, lon2);
          addRestMarker(restList);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FoodRecommend()));
        } else if (event[0].title == '이동') {
        } else {
          String tourInformation = '';
          tourInformation = await getTourInfo(event[0].title);

          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: SizedBox(
                        height: 350,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Container(child: Text(tourInformation)),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 240, 0, 0),
                                  child: ElevatedButton(
                                      child: Text("코스에서 삭제"),
                                      onPressed: () async {
                                        //pathlist에서 삭제해서 업데이트 해야함

                                        List<List<Place>> presetToBeUpdated =
                                            widget.getPreset();
                                        List<CalendarEventData<Event>>
                                            eventsToBeUpdated =
                                            widget.getEvents();
                                        List<List<Place>> presetUpdated = [
                                          for (int i = 0;
                                              i < presetToBeUpdated.length;
                                              i++)
                                            []
                                        ];

                                        int indexPreset = 0;
                                        int indexEvents = 0;
                                        int indexPath = 0;

                                        for (int i = 0;
                                            i < eventsToBeUpdated.length;
                                            i++) {
                                          if (eventsToBeUpdated[i].title ==
                                              event[0].title) {
                                            eventsToBeUpdated.removeAt(i);
                                          }
                                        }

                                        while (indexEvents <
                                                eventsToBeUpdated.length &&
                                            indexPreset <
                                                presetToBeUpdated.length) {
                                          print("while");
                                          if (eventsToBeUpdated[indexEvents]
                                                  .title ==
                                              '식사시간') {
                                            indexEvents++;
                                          } else if (eventsToBeUpdated[
                                                      indexEvents]
                                                  .title ==
                                              '이동') {
                                            indexEvents++;
                                          } else {
                                            if (eventsToBeUpdated[indexEvents]
                                                    .title !=
                                                presetToBeUpdated[indexPreset]
                                                        [indexPath]
                                                    .name) {
                                              indexPath++;

                                              if (indexPath >=
                                                  presetToBeUpdated[indexPreset]
                                                      .length) {
                                                indexPreset++;
                                                indexPath = 0;
                                              }
                                            } else {
                                              presetUpdated[indexPreset].add(
                                                  presetToBeUpdated[indexPreset]
                                                      [indexPath]);
                                              indexEvents++;
                                              indexPath++;

                                              print("여기까지옴");

                                              if (indexPath >=
                                                  presetToBeUpdated[indexPreset]
                                                      .length) {
                                                indexPreset++;
                                                indexPath = 0;
                                              }
                                            }
                                          }
                                        }

                                        List<List<int>> movingTimeList;

                                        if (widget.transit == 0) {
                                          movingTimeList =
                                              await createDrivingTimeList(
                                                  presetUpdated);
                                        } else {
                                          movingTimeList =
                                              await createTransitTimeList(
                                                  presetUpdated);
                                        }

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Timetable(
                                                      preset: presetUpdated,
                                                      movingTimeList:
                                                          movingTimeList,
                                                      transit: widget.transit,
                                                    )));

                                        print("pathlist updated");
                                        print(event);
                                      })),
                            ]))));
              });
        }
      },
      showLiveTimeLineInAllDays: false,
    ));
  }
}

class CreateEventPage extends StatefulWidget {
  final bool withDuration;
  final void Function(CalendarEventData<Event>)? onEventAdd;

  DateTime currentDate;

  final Function() getPreset;
  final Function() getEvents;
  final Function() getMovingTimeList;

  int transit = 0;

  CreateEventPage(
      {Key? key,
      this.withDuration = false,
      required this.getPreset,
      required this.transit,
      required this.getMovingTimeList,
      required this.getEvents,
      required this.currentDate,
      this.onEventAdd})
      : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  //DateTime _startDate = DateTime.now();
  //late DateTime _endDate;

  String newPlaceName = '';
  double newPlaceLat = 0;
  double newPlaceLon = 0;

  late DateTime _startTime;

  late DateTime _endTime;

  String _title = "";

  String _description = "";

  Color _color = Colors.blue;

  String _titleNode = '';

  late FocusNode _descriptionNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  //late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  //late TextEditingController _endDateController;

  /*
  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      date: widget.currentDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: widget.currentDate,
      title: _title,
      event: Event(
        title: _title,
      ),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }*/

  /*

  void _resetForm() {
    _form.currentState?.reset();
    //_startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }
*/

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _descriptionNode = FocusNode();
    _dateNode = FocusNode();

    //_startDateController = TextEditingController();
    //_endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _dateNode.dispose();

    //_startDateController.dispose();
    //_endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _TimetableState? parent =
        context.findAncestorStateOfType<_TimetableState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
        title: Text(
          "관광지 추가",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      latLen.add(newlatlang);

                      //move map camera to selected place with animation
                      //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                      var places = location.split(', ');
                      String placeName = places[places.length - 1];

                      //새로운 이벤트의 타이틀
                      _title = placeName;

                      //newPlace의 위도
                      newPlaceLat = lat;
                      newPlaceLon = lang;

                      print(_title);

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
                height: 15,
              ),
              Row(
                children: [
                  Expanded(child: Text('날짜 : ' + '${startDay}')),
                  SizedBox(width: 20.0),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: DateTimeSelectorFormField(
                      controller: _startTimeController,
                      decoration: AppConstants.inputDecoration.copyWith(
                        labelText: "시작 시간",
                      ),
                      validator: (value) {
                        if (value == null || value == "")
                          return "Please select start time.";

                        return null;
                      },
                      onSave: (date) => _startTime = date,
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 17.0,
                      ),
                      type: DateTimeSelectionType.time,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: DateTimeSelectorFormField(
                      controller: _endTimeController,
                      decoration: AppConstants.inputDecoration.copyWith(
                        labelText: "종료 시간",
                      ),
                      validator: (value) {
                        if (value == null || value == "")
                          return "Please select end time.";

                        return null;
                      },
                      onSave: (date) => _endTime = date,
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 17.0,
                      ),
                      type: DateTimeSelectionType.time,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              )

              /*
          TextFormField(
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Please enter event description.";

              return null;
            },
            onSaved: (value) => _description = value?.trim() ?? "",
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          )
          */
              ,
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Text(
                    "색상: ",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: _displayColorPicker,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: _color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                onTap: () async {
                  _form.currentState?.save();

                  final newEvent = CalendarEventData<Event>(
                    date: startDay,
                    color: _color,
                    endTime: _endTime,
                    startTime: _startTime,
                    description: _description,
                    title: _title,
                    event: Event(
                      title: _title,
                    ),
                  );

                  print('${newEvent.date}');
                  print(newEvent.title);
                  print("${newEvent.startTime}");
                  print("${newEvent.endTime}");

                  //newEvent 생성까지 완료.

                  List<List<Place>> presetToBeUpdated = widget.getPreset();
                  print(presetToBeUpdated);
                  //원래 코스 로드 완료

                  List<CalendarEventData<Event>> eventsToBeUpdated =
                      widget.getEvents();
                  print(eventsToBeUpdated);
                  //원래 이벤트리스트 로드 완료

                  CalendarEventData<Event> eventBefore = CalendarEventData(
                      title: 'dummy',
                      date: DateTime.now(),
                      startTime: DateTime.now(),
                      endTime: DateTime.now().add(Duration(hours: 1)));
                  CalendarEventData<Event> eventAfter = CalendarEventData(
                      title: 'dummy',
                      date: DateTime.now(),
                      startTime: DateTime.now(),
                      endTime: DateTime.now().add(Duration(hours: 1)));

                  Place newPlace = Place(
                      '${newEvent.title}',
                      newPlaceLat,
                      newPlaceLon,
                      _endTime.difference(_startTime).inMinutes,
                      30,
                      [10, 20, 30, 40, 50, 60, 70],
                      [10, 20, 30, 40, 50],
                      [10, 20, 30, 40, 50, 60],
                      [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110],
                      [10, 20, 30, 40]);

                  print(newPlace);
                  //newPlace 생성 완료

                  /*
                  for(int i=0; i< eventsToBeUpdated.length; i++){

                    if(newEvent.date.year == eventsToBeUpdated[i].date.year && newEvent.date.month == eventsToBeUpdated[i].date.month && newEvent.date.day == eventsToBeUpdated[i].date.day ){

                      if(newEvent.startTime.hour > eventsToBeUpdated[i].startTime.hour && newEvent.startTime.hour < eventsToBeUpdated[i+1].startTime.hour){

                        eventBefore = eventsToBeUpdated[i];
                        eventAfter = eventsToBeUpdated[i+1];

                        print(eventBefore);
                        print(eventAfter);

                      }

                    }

                  }

                   */

                  //eventBefore 찾기

                  for (int i = 0; i < eventsToBeUpdated.length; i++) {
                    if (newEvent.date.year == eventsToBeUpdated[i].date.year &&
                        newEvent.date.month ==
                            eventsToBeUpdated[i].date.month &&
                        newEvent.date.day == eventsToBeUpdated[i].date.day) {
                      if (eventsToBeUpdated[i].title != '식사시간' &&
                          eventsToBeUpdated[i].title != '이동') {
                        if (eventsToBeUpdated[i].startTime.hour <
                            newEvent.startTime.hour) {
                          eventBefore = eventsToBeUpdated[i];
                          print(eventBefore.title);
                          //eventBefore 찾기 완료
                        }
                      }
                    }
                  }

                  for (int i = 0; i < presetToBeUpdated.length; i++) {
                    for (int j = 0; j < presetToBeUpdated[i].length; j++) {
                      if (presetToBeUpdated[i][j].name == eventBefore.title) {
                        presetToBeUpdated[i].insert(j + 1, newPlace);

                        print("path updated");
                        print(presetToBeUpdated);
                      }
                    }
                  }

                  List<List<int>> movingTimeList = [];

                  if (widget.transit == 0) {
                    movingTimeList =
                        (await createDrivingTimeList(presetToBeUpdated));
                  } else {
                    movingTimeList =
                        (await createTransitTimeList(presetToBeUpdated));
                  }

                  //print(movingTimeList);

                  if (movingTimeList.isEmpty) {
                    print('movimgTimeList is empty');
                  }

                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Timetable(
                                preset: presetToBeUpdated,
                                movingTimeList: movingTimeList,
                                transit: widget.transit,
                              )));
                },
                title: "관광지 추가",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

class AddEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<Event>)? onEventAdd;


  const AddEventWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  DateTime _startDate = DateTime(2022,11,10);
  //late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "";

  String _description = "";

  Color _color = Colors.blue;

  late FocusNode _titleNode;

  late FocusNode _descriptionNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  //late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  //late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();

    //_startDateController = TextEditingController();
    //_endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();

    //_startDateController.dispose();
    //_endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "관광지 검색",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            onSaved: (value) => _title = value?.trim() ?? "",
            validator: (value) {
              if (value == null || value == "")
                return "관광지명을 검색하세요";

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: Text('날짜 : '+'${_startDate}'
                  )),


              SizedBox(width: 20.0),

            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _startTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "시작 시간",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select start time.";

                    return null;
                  },
                  onSave: (date) => _startTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _endTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "종료 시간",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select end time.";

                    return null;
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),


          TextFormField(
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Please enter event description.";

              return null;
            },
            onSaved: (value) => _description = value?.trim() ?? "",
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          )

          ,
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "색상: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _color,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: () {
/*
              context.read<PathInformation>().insertPath(  Place(
              '신사역',
              2,
              33.4,
              43.2,
              30,
              [10, 20, 30, 40, 50, 60, 70],
              [10, 20, 30, 40, 50],
              [10, 20, 30, 40, 50, 60],
              [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110],
              [10, 20, 30, 40]
              ));
              final move = context.watch<PathInformation>().;
              print(move);

*/

            },
            title: "관광지 추가",
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      date: _startDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: _startDate,
      title: _title,
      event: Event(
        title: _title,
      ),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    //_startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 */
