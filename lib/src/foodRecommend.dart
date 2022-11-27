import 'package:danim/src/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../components/image_data.dart';
import 'package:danim/map.dart';
import 'package:danim/nearby.dart';
import 'package:danim/src/timetable.dart';
class FoodRecommend extends StatefulWidget {
  const FoodRecommend({super.key});

  @override
  FoodRecommendState createState() => FoodRecommendState();
}
class FoodRecommendState extends State<FoodRecommend> {
  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;

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
                  zoom: 8.0),
              mapType: _mapType,
              markers: markers,
              pathOverlays: pathOverlays,
            )));
  }
}
