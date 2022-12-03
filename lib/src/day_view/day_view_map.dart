import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/image_data.dart';
import 'day_view.dart';
import 'package:danim/map.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class DayViewMap extends StatefulWidget {
  @override
  DayViewMapState createState() => DayViewMapState();

}

class DayViewMapState extends State<DayViewMap> {
  @override
  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;

  @override
  Widget build(BuildContext context) {

    //WillPopScope는 사용자가 빽키를 눌렀을때 작동되는 위젯
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
            body: Container(
                child: NaverMap(
                  onMapCreated: (mcontroller) {
                    setState(() {
                      mapController = mcontroller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                      bearing: 0.0,
                      target: LatLng(33.371964, 126.543512),
                      tilt: 0.0,
                      zoom: 9.0),
                  mapType: _mapType,
                  markers: markers,
                  pathOverlays: pathOverlays,
                )));
  }
}