// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'firebase_read_write.dart';

class RouteAI extends StatelessWidget {
  final point_city_ctrl = TextEditingController();
  final point_name_ctrl = TextEditingController();
  double point_latitude_ctrl = 0.00;
  double point_longitude_ctrl = 0.00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //상단바
          title: Text(
              "코스 추천 AI"), //Myapp class의 매개인자 가져옴 : Testing Thomas Home Page
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Point City',
                      ))),
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextField(
                      controller: point_name_ctrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Point Name',
                      ))),
              // Text('Point X coordinate : ' + point_x_ctrl),
              // Text('Point Y coordinate : ' + point_y_ctrl),
              Text(point_latitude_ctrl.toString()),
              Text(point_longitude_ctrl.toString()),
              ElevatedButton(
                onPressed: () async {
                  print('ElevatedButton - onPressed');
                  var read = ReadController(); //Read컨트롤러 클래스 생성
                  //var read_data = List<double>.generate(2, (index) => 0.00);
                  List<double> read_data;
                  read_data = await read.fb_read_point(
                          point_city_ctrl.text, point_name_ctrl.text)
                      as List<double>;
                  print(read_data);

                  //point_latitude_ctrl = read_data[0];
                  //point_longitude_ctrl = read_data[1];
                },
                onLongPress: () {
                  print('ElevatedButton - onLongPress');
                },
                // button 스타일은 여기서 작성한다.
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 0, 102, 255),
                ),
                child: const Text('검색'),
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
}
