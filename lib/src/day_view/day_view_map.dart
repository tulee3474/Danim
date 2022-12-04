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
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },

            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),

            // child: Transform(
            //   transform: Matrix4.translationValues(0, 0.0, 0.0),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Image.asset(IconsPath.logo,
            //             fit: BoxFit.contain, height: 40)
            //       ]),
            // ),
          ),
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
