import 'package:danim/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
//import 'package:danim/src/exampleResource.dart';
import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import '../model/event.dart';

import 'myJourney.dart';

List<CalendarEventData> journey1 = [event1, event2, event3];
List<CalendarEventData> journey2 = [event4, event5, event6];

CalendarEventData event1 = CalendarEventData(
  title: '성산일출봉',
  date: DateTime(2022, 5, 14),
  event: Event(title: '성산일출봉'),
  description: '',
  startTime: DateTime(2022, 5, 14, 13),
  endTime: DateTime(2022, 5, 14, 15),
);

CalendarEventData event2 = CalendarEventData(
  title: '비자림',
  date: DateTime(2022, 5, 14),
  event: Event(title: '비자림'),
  description: '',
  startTime: DateTime(2022, 5, 14, 15),
  endTime: DateTime(2022, 5, 14, 17),
);

CalendarEventData event3 = CalendarEventData(
  title: '금악오름',
  date: DateTime(2022, 5, 15),
  event: Event(title: '금악오름'),
  description: '',
  startTime: DateTime(2022, 5, 15, 13),
  endTime: DateTime(2022, 5, 15, 15),
);

//

CalendarEventData event4 = CalendarEventData(
  title: '설악산',
  date: DateTime(2022, 6, 7),
  event: Event(title: '설악산'),
  description: '',
  startTime: DateTime(2022, 6, 7, 13),
  endTime: DateTime(2022, 6, 7, 15),
);
CalendarEventData event5 = CalendarEventData(
  title: '우도',
  date: DateTime(2022, 6, 7),
  event: Event(title: '우도'),
  description: '',
  startTime: DateTime(2022, 6, 7, 13),
  endTime: DateTime(2022, 5, 14, 15),
);
CalendarEventData event6 = CalendarEventData(
  title: '씨발',
  date: DateTime(2022, 6, 8),
  event: Event(title: '씨발'),
  description: '',
  startTime: DateTime(2022, 6, 8, 13),
  endTime: DateTime(2022, 6, 8, 15),
);

List<DateTime> dates_ex = [DateTime(2022, 5, 14), DateTime(2022, 5, 15)];

class Community extends StatelessWidget {
  List<List<CalendarEventData>> journeys = [journey1, journey2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Container());
  }
}
