import 'package:danim/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/model/event.dart';
import 'package:danim/pages/create_event_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/exampleResource.dart';

import '../widgets/add_event_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/date_time_selector.dart';
import 'foodRecommend.dart';

List<CalendarEventData<Event>> createEventList(List<Place> path,
    List<int> moving_time, DateTime startDay, DateTime endDay) {
  int startDayTime = 7;
  int endDayTime = 21;
  DateTime startDay = DateTime(2022, 11, 15);
  DateTime endDay = DateTime(2022, 11, 17);

  int timeIndex = startDayTime;
  DateTime dayIndex = startDay;

  List<CalendarEventData<Event>> events = [];

  for (int i = 0; i < path.length; i++) {
    if ((timeIndex > endDayTime) ||
        ((timeIndex + path[i].time) > endDayTime) ||
        timeIndex + moving_time[i] > endDayTime) {
      dayIndex = dayIndex.add(const Duration(days: 1));
      timeIndex = startDayTime;
    }

    if ((11 <= timeIndex && timeIndex < 14) ||
        (17 <= timeIndex && timeIndex < 20)) {
      events.add(CalendarEventData(
          title: '식사시간',
          date: dayIndex,
          event: Event(title: '식사시간'),
          description: '',
          startTime:
              DateTime(dayIndex.year, dayIndex.month, dayIndex.day, timeIndex),
          endTime: DateTime(
              dayIndex.year, dayIndex.month, dayIndex.day, timeIndex += 2),
          color: Colors.orangeAccent));
    }

    if ((timeIndex > endDayTime) ||
        ((timeIndex + path[i].time) > endDayTime) ||
        timeIndex + moving_time[i] > endDayTime) {
      dayIndex = dayIndex.add(const Duration(days: 1));
      timeIndex = startDayTime;
    }

    if ((11 <= timeIndex && timeIndex < 14) ||
        (17 <= timeIndex && timeIndex < 20)) {
      events.add(CalendarEventData(
          title: '식사시간',
          date: dayIndex,
          event: Event(title: '식사시간'),
          description: '',
          startTime:
              DateTime(dayIndex.year, dayIndex.month, dayIndex.day, timeIndex),
          endTime: DateTime(
              dayIndex.year, dayIndex.month, dayIndex.day, timeIndex += 2),
          color: Colors.orangeAccent));
    }

    events
      ..add(CalendarEventData(
          title: '${path[i].name}',
          date: dayIndex,
          event: Event(title: '${path[i].name}'),
          description: '',
          startTime:
              DateTime(dayIndex.year, dayIndex.month, dayIndex.day, timeIndex),
          endTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
              timeIndex += path[i].time)));

    if ((timeIndex > endDayTime) ||
        ((timeIndex + path[i].time) > endDayTime) ||
        timeIndex + moving_time[i] > endDayTime) {
      dayIndex = dayIndex.add(const Duration(days: 1));
      timeIndex = startDayTime;
    }
    if ((11 <= timeIndex && timeIndex < 13) ||
        (17 <= timeIndex && timeIndex < 19)) {
      events.add(CalendarEventData(
          title: '식사시간',
          date: dayIndex,
          event: Event(title: '식사시간'),
          description: '',
          startTime:
              DateTime(dayIndex.year, dayIndex.month, dayIndex.day, timeIndex),
          endTime: DateTime(
              dayIndex.year, dayIndex.month, dayIndex.day, timeIndex += 2),
          color: Colors.orangeAccent));
    }

    events.add(CalendarEventData(
        title: '이동',
        date: dayIndex,
        event: Event(title: '이동'),
        description: '',
        startTime:
            DateTime(dayIndex.year, dayIndex.month, dayIndex.day, timeIndex),
        endTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
            timeIndex += moving_time[i]),
        color: Colors.grey));
  }

  return events;
}

List<CalendarEventData<Event>> events = [];

class Timetable extends StatelessWidget {
  List<Place> path = [];
  List<int> moving_time = [];

  Timetable(this.path, this.moving_time);

  late List<CalendarEventData<Event>> events =
      createEventList(path, moving_time, startDay, endDay);

  void addPlace(Place newPlace) {
    path.add(newPlace);
  }

  void deletePlace(Place place) {
    path.remove(place);
  }

  void setEventList() {
    events = createEventList(path, moving_time, startDay, endDay);
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
                        fit: BoxFit.contain, height: 20))
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
                        withDuration: true,
                      ));
                      if (event == null) return;
                      CalendarControllerProvider.of<Event>(context)
                          .controller
                          .add(event);
                    },
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    child: Icon(Icons.fastfood_rounded),
                    elevation: 8,
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FoodRecommend()))
                    },
                  ))
            ]),
            body: DayViewWidget()));
  }
}

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DayView<Event>(
      minDay: startDay,
      maxDay: endDay,
      key: state,
      width: width,
      onEventTap: (event, date) => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                content: SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: [
                          Container(child: Text('${event}')),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 240, 0, 0),
                              child: ElevatedButton(
                                  child: Text("코스에서 삭제"),
                                  onPressed: () => {
                                        //pathlist에서 삭제해서 업데이트 해야함

                                        print("pathlist updated"),
                                        print(event)
                                      }))
                        ]))));
          }),
      showLiveTimeLineInAllDays: false,
    ));
  }
}

class CreateEventPage extends StatefulWidget {
  final bool withDuration;

  const CreateEventPage({Key? key, this.withDuration = false})
      : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: AddEventWidget(
          onEventAdd: context.pop,
        ),
      ),
    );
  }
}

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
  DateTime _startDate = DateTime(2022, 11, 10);
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
              if (value == null || value == "") return "관광지명을 검색하세요";

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
              Expanded(child: Text('날짜 : ' + '${_startDate}')),
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
            onTap: () => {print("path updated")},
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
