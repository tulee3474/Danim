import 'dart:convert';

//import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

String apiKEY = 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI';
String apiURL = 'https://maps.googleapis.com/maps/api/directions/json?';
String drivingURL =
    'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?';

class TransitTime{
  int transitDuration=0;
  String transitSteps='';

  TransitTime(
      this.transitDuration,
      this.transitSteps
      );
}

Future<int> getDrivingDuration(double originLat, double originLng, double destinationLat, double destinationLng) async {
  int drivingDuration=0;
  http.Response response = await http.get(Uri.parse(
      '${drivingURL}start=$originLng,$originLat&goal=$destinationLng,$destinationLat&option=trafast'
  ),headers: {"X-NCP-APIGW-API-KEY-ID": "piv474r6sz",
    "X-NCP-APIGW-API-KEY": "Ugcq7WpbmUSu010hzNpE4bFFXO1E3Ds983KBKwSI"}
  );
  if (response.statusCode < 200 || response.statusCode > 400) {
    return -1; // 오류시 -1 리턴
  } else {
    String responseData=utf8.decode(response.bodyBytes);
    var responseBody=jsonDecode(responseData);
    if (responseBody['code']!='0') {
      drivingDuration = (responseBody['route']['trafast'][0]['summary']['duration']);
      drivingDuration = (((drivingDuration / 60000).ceil() + 9) / 10).floor() * 10;
      if (drivingDuration>120) {
        drivingDuration=120;
      }
    }
    else {drivingDuration=-1;}
  }
  return drivingDuration;
}

Future<TransitTime> getTransitDuration(double originLat, double originLng, double destinationLat, double destinationLng) async {
  String transitSteps='';
  int transitDuration=0;
  http.Response response = await http.get(Uri.parse(
      '${apiURL}origin=$originLat,$originLng&destination=$destinationLat,$destinationLng&mode=transit&departure_time=1684292461&language=ko&key=$apiKEY'
  ),
  );
  if (response.statusCode < 200 || response.statusCode > 400) {
    return TransitTime(-1,'Error'); // 오류시 -1 리턴
  } else {
    String responseData = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(responseData);
    String status=responseBody["status"];
    if(status=="ZERO_RESULTS") {
      transitSteps="이동경로가 없습니다.";
      transitDuration=((await getDrivingDuration(originLat, originLng, destinationLat, destinationLng))*1.5).round();
    }
    else {
      transitDuration = responseBody["routes"][0]["legs"][0]["duration"]["value"];
      transitDuration=(((transitDuration/60).ceil()+9)/10).floor()*10;
      if (transitDuration>180) {
        transitDuration=180;
      }
      transitSteps=await getTransitSteps(originLat, originLng, destinationLat, destinationLng);
    }
  }
  return TransitTime(transitDuration, transitSteps);
}

Future<String> getTransitSteps(double originLat, double originLng, double destinationLat, double destinationLng) async {
  String transitSteps='';
  http.Response response = await http.get(Uri.parse(
      '${apiURL}origin=$originLat,$originLng&destination=$destinationLat,$destinationLng&mode=transit&departure_time=now&language=ko&key=$apiKEY'
  ),
  );
  if (response.statusCode < 200 || response.statusCode > 400) {
    transitSteps = 'Error'; // Error 반환
  } else {
    String responseData = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(responseData);
    var list = (responseBody["routes"][0]["legs"][0]["steps"]);

    String startAddress=responseBody["routes"][0]["legs"][0]["start_address"].toString();
    String endAddress=responseBody["routes"][0]["legs"][0]["end_address"].toString();
    String totalDistance=responseBody["routes"][0]["legs"][0]["distance"]["text"].toString();
    String totalDuration=responseBody["routes"][0]["legs"][0]["duration"]["text"].toString();
    String info='$startAddress에서 $endAddress까지 $totalDistance $totalDuration\n';
    transitSteps+='$info \n\n';
    for (int i = 0; i < list.length; i++) {
      if (list[i]["travel_mode"] == "WALKING") {
        String steps=list[i]["html_instructions"].toString();
        String distance=list[i]["distance"]["text"].toString();
        String subDuration=list[i]["duration"]["text"].toString();
        transitSteps += '$steps $distance $subDuration \n';
      } else {
        String transit='${list[i]["transit_details"]["line"]["name"]} ${list[i]["transit_details"]["line"]["short_name"]}';
        String headSign=list[i]["html_instructions"].toString();
        String departureStop=list[i]["transit_details"]["departure_stop"]["name"].toString();
        String arrivalStop=list[i]["transit_details"]["arrival_stop"]["name"].toString();
        String stops=list[i]["transit_details"]["num_stops"].toString();
        String subDuration=list[i]["duration"]["text"].toString();
        transitSteps +='$transit $headSign $departureStop에서 $arrivalStop까지 $stops정거장 $subDuration\n';
      }
    }
  }
  return transitSteps;
}