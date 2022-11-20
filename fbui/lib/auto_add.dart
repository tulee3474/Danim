import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

String apiKEY = 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI';
String placeURL =
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?';

Future<LatLng> getLocation(String place) async {
  LatLng latLng;
  http.Response response = await http.get(
    Uri.parse(
        '${placeURL}input=$place&inputtype=textquery&fields=formatted_address,name,geometry&key=$apiKEY'),
    headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"},
  );

  if (response.statusCode < 200 || response.statusCode > 400) {
    return LatLng(0, 0); // 오류시 -1 리턴
  } else {
    String responseData = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(responseData);
    double lat = responseBody["candidates"][0]["geometry"]["location"]["lat"];
    double lng = responseBody["candidates"][0]["geometry"]["location"]["lng"];
    latLng = LatLng(lat, lng);
  }
  return latLng;
}

Future<void> fb_auto_write_place(city, name) async {
  //CollectionReference points = FirebaseFirestore.instance.collection('points');

  //덮어쓰기
  // FirebaseFirestore.instance.collection('points').doc(city).set({
  //   'name': name,
  //   'xCoordinate': xCoordinate,
  //   'yCoordinate': yCoordinate,
  // }, SetOptions(merge: false));

  print("에러");
  LatLng tmp = await getLocation(name);
  print("에러");

  //합쳐쓰기
  FirebaseFirestore.instance.collection(city).doc(name).set({
    'latitude': tmp.latitude,
    'longitude': tmp.longitude,
    'takenTime': 60,
    'popular': 60,
    'partner': [60, 60, 60, 60, 60, 60, 60],
    'concept': [60, 60, 60, 60],
    'play': [60, 60, 60, 60, 60, 60],
    'tour': [60, 60, 60, 60, 60, 60, 60, 60, 60],
    'season': [60, 60, 60, 60],
  }, SetOptions(merge: true));
  print("에러");

  //관광지 목록에 이름 작성
  FirebaseFirestore.instance.collection(city).doc("관광지목록").update({
    "관광지": FieldValue.arrayUnion([name]),
  });

  print("파이어베이스 업로드 완료");
}

class AutoAddPage extends StatelessWidget {
  final point_city_ctrl = TextEditingController();
  final point_name_ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //상단바
          title: Text(
              "관광지 자동 추가"), //Myapp class의 매개인자 가져옴 : Testing Thomas Home Page
          centerTitle: true, //중앙정렬
          backgroundColor: Colors.redAccent,
          elevation: 5.0, //붕떠 있는 느낌(바 하단 그림자)

          actions: [
            //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
            //이곳에 한개 이상의 위젯들을 가진다.
            ElevatedButton(
              onPressed: () {
                print('ElevatedButton - onPressed');
                Navigator.pop(context);
              },
              onLongPress: () {
                print('ElevatedButton - onLongPress');
              },
              // button 스타일은 여기서 작성한다.
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.orange,
              ),
              child: const Text('돌아가기'),
            ),
          ],
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //가로축 정렬을 위한 위젯
                children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextField(
                      controller: point_city_ctrl,
                      onSubmitted: (String value) {
                        print("서울");
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '서울',
                      ))),
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextField(
                      controller: point_name_ctrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Place Name',
                      ))),

              // Text('Point X coordinate : ' + point_x_ctrl),
              // Text('Point Y coordinate : ' + point_y_ctrl),
              Text("성향 점수 기본값은 60입니다."),
              ElevatedButton(
                onPressed: () async {
                  print('ElevatedButton - onPressed');
                  if (point_city_ctrl.text.length > 0) {
                    fb_auto_write_place(
                        point_city_ctrl.text, point_name_ctrl.text);
                  } else {
                    fb_auto_write_place("서울", point_name_ctrl.text);
                  }

                  point_name_ctrl.text = "";
                },
                onLongPress: () {
                  print('ElevatedButton - onLongPress');
                  if (point_city_ctrl.text.length > 0) {
                    fb_auto_write_place(
                        point_city_ctrl.text, point_name_ctrl.text);
                  } else {
                    fb_auto_write_place("서울", point_name_ctrl.text);
                  }
                  point_name_ctrl.text = "";
                },
                // button 스타일은 여기서 작성한다.
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 0, 102, 255),
                ),
                child: const Text('업로드'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('ElevatedButton - onPressed');
                  Navigator.pop(context);
                },
                onLongPress: () {
                  print('ElevatedButton - onLongPress');
                },
                // button 스타일은 여기서 작성한다.
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orange,
                ),
                child: const Text('돌아가기'),
              ),
            ])));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
