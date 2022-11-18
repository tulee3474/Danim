import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';

import 'loading.dart';

class CourseDetail extends StatefulWidget {
  //const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool private_car = false, public_transportation = false;
  List selectList = [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0]
  ];

  String str = '';

  void setState(VoidCallback fn) {
    str += "in SetState\n";
    super.setState(fn);
  }

  static Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    }
    if (states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    } else
      return Colors.white;
  }

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
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('이번 여행, 어떤 교통수단을 이용하세요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(children: [
                  ElevatedButton(
                      child: Text('자차', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () =>
                          {private_car = true, print(private_car)}),
                  ElevatedButton(
                      child:
                          Text('대중교툥', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            public_transportation = true,
                            print(public_transportation)
                          })
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('이번 여행, 누구와 떠나시나요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(children: [
                Row(children: <Widget>[
                  ElevatedButton(
                      child:
                          Text('혼자여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][0] == 0)
                              {selectList[0][0] = 1}
                            else
                              {selectList[0][0] = 0},
                            print(selectList[0][0])
                          }),
                  ElevatedButton(
                      child:
                          Text('커플여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][1] == 0)
                              {selectList[0][1] = 1}
                            else
                              {selectList[0][1] = 0},
                            print(selectList[0][1])
                          }),
                  ElevatedButton(
                      child:
                          Text('우정여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][2] == 0)
                              {selectList[0][2] = 1}
                            else
                              {selectList[0][2] = 0},
                            print(selectList[0][2])
                          }),
                  ElevatedButton(
                      child:
                          Text('가족여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][3] == 0)
                              {selectList[0][3] = 1}
                            else
                              {selectList[0][3] = 0},
                            print(selectList[0][3])
                          }),
                  ElevatedButton(
                      child:
                          Text('효도여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][4] == 0)
                              {selectList[0][4] = 1}
                            else
                              {selectList[0][4] = 0},
                            print(selectList[0][4])
                          })
                ]),
                Row(children: [
                  ElevatedButton(
                      child:
                          Text('어린자녀와', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][5] == 0)
                              {selectList[0][5] = 1}
                            else
                              {selectList[0][5] = 0},
                            print(selectList[0][5])
                          }),
                  ElevatedButton(
                      child:
                          Text('반려견과', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[0][6] == 0)
                              {selectList[0][6] = 1}
                            else
                              {selectList[0][6] = 0},
                            print(selectList[0][6])
                          })
                ])
              ]),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('이번 여행의 테마는 무엇인가요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(children: [
                  ElevatedButton(
                      child: Text('힐링', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[1][0] == 0)
                              {selectList[1][0] = 1}
                            else
                              {selectList[1][0] = 0},
                            print(selectList[1][0])
                          }),
                  ElevatedButton(
                      child:
                          Text('액티비티', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[1][1] == 0)
                              {selectList[1][1] = 1}
                            else
                              {selectList[1][1] = 0},
                            print(selectList[1][1])
                          }),
                  ElevatedButton(
                      child:
                          Text('배움이 있는', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[1][2] == 0)
                              {selectList[1][2] = 1}
                            else
                              {selectList[1][2] = 0},
                            print(selectList[1][2])
                          }),
                  ElevatedButton(
                      child: Text('맛있는', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {
                            if (selectList[1][3] == 0)
                              {selectList[1][3] = 1}
                            else
                              {selectList[1][3] = 0},
                            print(selectList[1][3])
                          })
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('이번 여행에서 어떤 것들을 하고 싶으세요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(children: [
                  Row(children: [
                    ElevatedButton(
                        child: Text('레저스포츠',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][0] == 0)
                                {selectList[2][0] = 1}
                              else
                                {selectList[2][0] = 0},
                              print(selectList[2][0])
                            }),
                    ElevatedButton(
                        child:
                            Text('문화시설', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][1] == 0)
                                {selectList[2][1] = 1}
                              else
                                {selectList[2][1] = 0},
                              print(selectList[2][1])
                            }),
                    ElevatedButton(
                        child:
                            Text('사진', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][2] == 0)
                                {selectList[2][2] = 1}
                              else
                                {selectList[2][2] = 0},
                              print(selectList[2][2])
                            }),
                    ElevatedButton(
                        child:
                            Text('이색체험', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][3] == 0)
                                {selectList[2][3] = 1}
                              else
                                {selectList[2][3] = 0},
                              print(selectList[2][3])
                            }),
                    ElevatedButton(
                        child:
                            Text('문화체험', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][4] == 0)
                                {selectList[2][4] = 1}
                              else
                                {selectList[2][4] = 0},
                              print(selectList[2][4])
                            }),
                  ]),
                  Row(children: [
                    ElevatedButton(
                        child:
                            Text('역사', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[2][5] == 0)
                                {selectList[2][5] = 1}
                              else
                                {selectList[2][5] = 0},
                              print(selectList[2][5])
                            })
                  ])
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('이번 여행, 어떤 곳들을 가고 싶으세요?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ))),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(children: [
                  Row(children: [
                    ElevatedButton(
                        child:
                            Text('바다', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][0] == 0)
                                {selectList[3][0] = 1}
                              else
                                {selectList[3][0] = 0},
                              print(selectList[3][0])
                            }),
                    ElevatedButton(
                        child: Text('산', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][1] == 0)
                                {selectList[3][1] = 1}
                              else
                                {selectList[3][1] = 0},
                              print(selectList[3][1])
                            }),
                    ElevatedButton(
                        child: Text('드라이브코스',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][2] == 0)
                                {selectList[3][2] = 1}
                              else
                                {selectList[3][2] = 0},
                              print(selectList[3][2])
                            }),
                    ElevatedButton(
                        child:
                            Text('산책', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][3] == 0)
                                {selectList[3][3] = 1}
                              else
                                {selectList[3][3] = 0},
                              print(selectList[3][3])
                            })
                  ]),
                  Row(children: [
                    ElevatedButton(
                        child:
                            Text('쇼핑', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][4] == 0)
                                {selectList[3][4] = 1}
                              else
                                {selectList[3][4] = 0},
                              print(selectList[3][4])
                            }),
                    ElevatedButton(
                        child: Text('실내여행지',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][5] == 0)
                                {selectList[3][5] = 1}
                              else
                                {selectList[3][5] = 0},
                              print(selectList[3][5])
                            }),
                    ElevatedButton(
                        child:
                            Text('시티투어', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][6] == 0)
                                {selectList[3][6] = 1}
                              else
                                {selectList[3][6] = 0},
                              print(selectList[3][6])
                            }),
                    ElevatedButton(
                        child:
                            Text('지역축제', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][7] == 0)
                                {selectList[3][7] = 1}
                              else
                                {selectList[3][7] = 0},
                              print(selectList[3][7])
                            }),
                    ElevatedButton(
                        child:
                            Text('전통한옥', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              if (selectList[3][8] == 0)
                                {selectList[3][8] = 1}
                              else
                                {selectList[3][8] = 0},
                              print(selectList[3][8])
                            })
                  ])
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),
            Container(
                width: 150.0,
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loading()));
                    },
                    child: Text('추천코스 받기')))
          ],
        ));
  }
}
