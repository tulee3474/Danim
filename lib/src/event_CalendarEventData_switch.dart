import 'package:danim/model/event.dart';

import '../calendar_view.dart';

List<CalendarEventData> eventsToCalendarEventData (List<CalendarEventData<Event>> events){

  List<CalendarEventData> eventsForDB = [];

  for(int i=0; i<events.length; i++){

    eventsForDB.add(
      CalendarEventData(
        title: events[i].title,
        date: events[i].date,
        description: events[i].description,
        latitude: events[i].latitude,
        longitude: events[i].longitude,
        startTime: events[i].startTime,
        endTime: events[i].endTime
      )
    );

  }



  return eventsForDB;


}



List<CalendarEventData<Event>> calendarEventDataToEvents (List<CalendarEventData> eventsforDB) {
  List<CalendarEventData<Event>> events = [];

  for (int i = 0; i < eventsforDB.length; i++) {
    events.add(
        CalendarEventData(
            title: eventsforDB[i].title,
            date: eventsforDB[i].date,
            event:Event(title: eventsforDB[i].title),
            latitude: eventsforDB[i].latitude,
            longitude: eventsforDB[i].longitude,
            description: eventsforDB[i].description,
            startTime: eventsforDB[i].startTime,
            endTime: eventsforDB[i].endTime
        )
    );
  }


  return events;
}

