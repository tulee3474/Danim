import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/src/place.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'exampleResource.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Preset extends StatelessWidget {
  List<List<Place>> courses = [];

  Preset(this.courses);

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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
                child: Column(children: <Widget>[
              for (int i = 0; i < courses.length; i++)
                Stack(children: [
                  Container(
                      child: ElevatedButton(
                          child: Text('${courses[i][0].name}'),
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Timetable(
                                            courses[i], moving_time_ex)))
                              })),
                  Positioned(
                      right: -20,
                      child: Container(
                          child: TextButton(
                              child:
                                  Icon(Icons.arrow_forward, color: Colors.red),
                              onPressed: () => {print(courses[i])})))
                ]),
            ]))));
  }
}
