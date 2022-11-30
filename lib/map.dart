import 'package:danim/src/courseSelected.dart';
import 'package:flutter/material.dart';
import 'nearby.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'package:danim/src/place.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'route_ai.dart';
List<Color> colorList=[
  Colors.pink,Colors.orange,Colors.yellow,Colors.green,Colors.blue,Colors.indigo,Colors.purple,Colors.black
];
// list of locations to display polylines

//];
List<LatLng> accommodationLatLen = [
  //const LatLng(37.507941, 127.009686),
  //const LatLng(37.302263, 126.977977)
];

List<Marker> markers = [];
Set<PathOverlay> pathOverlays = {};
//List<Place> pathTemp=[];


List<LatLng> latLen3 = [
  //const LatLng(37.507941, 127.009686),
  //const LatLng(37.302263, 126.977977)
];
List<LatLng> latLen=[];
List<Place> pathTemp=[];

String location="장소를 검색하세요";
void addMarker(List<Place> pathList) {
  markers.clear();
  pathTemp=pathList;
  for (int i = 0; i < pathList.length; i++) {
    markers.add(Marker(
      markerId: pathList[i].name,
      position: LatLng(pathList[i].latitude, pathList[i].longitude),
      infoWindow: pathList[i].name,
      width: 20,
      height: 20,
    ));
  }
}

void addPoly(List<Place> pathList) {
  pathOverlays.clear();
  latLen.clear();
  //print(pathList[i].name);
  for (int i = 0; i < pathList.length; i++) {
    latLen.add(LatLng(pathList[i].latitude, pathList[i].longitude));
    //print(pathList[i].name);
  }
  if(latLen.length>1) {
    pathOverlays.add(
        PathOverlay(PathOverlayId('path$course_selected_day_index'), latLen,
            color: colorList[course_selected_day_index],
            width: 7,
            outlineWidth: 0));
  }
}
void addRestMarker(List<Restaurant> restList) {
  markers.clear();
  addMarker(pathTemp);
  for(int i=0;i<restList.length;i++) {
    markers.add(Marker(
      markerId: restList[i].restName,
      position: LatLng(restList[i].restLat, restList[i].restLong),
      infoWindow: '${restList[i].restName}\n${restList[i].restCategory}',
      captionColor: Colors.purple,
      captionHaloColor: Colors.purple,
      iconTintColor: Colors.purple,
      width: 20,
      height: 20,
    ));
  }
}

