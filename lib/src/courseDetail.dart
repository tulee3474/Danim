import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
import 'package:danim/src/exampleResource.dart';

import 'loading.dart';

class CourseDetail extends StatefulWidget {
  //const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool private_car = false, public_transportation = false;

  bool alone = false,
      couple = false,
      friend = false,
      family = false,
      hyodo = false,
      kid = false,
      pet = false;
  bool healing = false,
      activity = false,
      learning = false,
      leisure = false,
      tasty = false;
  bool leisure_sport = false,
      culture_facility = false,
      picture = false,
      experience = false,
      culture_experience = false,
      history = false;
  bool beach = false,
      mountain = false,
      nature = false,
      trekking = false,
      drive = false,
      walk = false,
      shopping = false,
      indoor = false,
      city = false,
      festival = false,
      traditional_house = false;
  bool spring = false, summer = false, autumn = false, winter = false;

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
                      onPressed: () => {alone = true, print(alone)}),
                  ElevatedButton(
                      child:
                          Text('커플여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {couple = true, print(couple)}),
                  ElevatedButton(
                      child:
                          Text('우정여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {friend = true, print(friend)}),
                  ElevatedButton(
                      child:
                          Text('가족여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {family = true, print(family)}),
                  ElevatedButton(
                      child:
                          Text('효도여행', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {hyodo = true, print(hyodo)})
                ]),
                Row(children: [
                  ElevatedButton(
                      child:
                          Text('어린자녀와', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {kid = true, print(kid)}),
                  ElevatedButton(
                      child:
                          Text('반려견과', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {pet = true, print(pet)})
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
                      onPressed: () => {healing = true, print(healing)}),
                  ElevatedButton(
                      child:
                          Text('액티비티', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {activity = true, print(activity)}),
                  ElevatedButton(
                      child:
                          Text('배움이 있는', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {learning = true, print(learning)}),
                  ElevatedButton(
                      child:
                          Text('여유로운', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {leisure = true, print(leisure)}),
                  ElevatedButton(
                      child: Text('맛있는', style: TextStyle(color: Colors.black)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(getColor)),
                      onPressed: () => {tasty = true, print(tasty)})
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
                        onPressed: () =>
                            {leisure_sport = true, print(leisure_sport)}),
                    ElevatedButton(
                        child:
                            Text('문화시설', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () =>
                            {culture_facility = true, print(culture_facility)}),
                    ElevatedButton(
                        child:
                            Text('사진', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {picture = true, print(picture)}),
                    ElevatedButton(
                        child:
                            Text('이색체험', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () =>
                            {experience = true, print(experience)}),
                    ElevatedButton(
                        child:
                            Text('문화체험', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              culture_experience = true,
                              print(culture_experience)
                            }),
                  ]),
                  Row(children: [
                    ElevatedButton(
                        child:
                            Text('역사', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {history = true, print(history)})
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
                        onPressed: () => {beach = true, print(beach)}),
                    ElevatedButton(
                        child: Text('산', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {mountain = true, print(mountain)}),
                    ElevatedButton(
                        child:
                            Text('자연', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {nature = true, print(nature)}),
                    ElevatedButton(
                        child:
                            Text('트레킹', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {trekking = true, print(trekking)}),
                    ElevatedButton(
                        child:
                            Text('드라이브', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {drive = true, print(drive)}),
                    ElevatedButton(
                        child:
                            Text('산책', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {walk = true, print(walk)})
                  ]),
                  Row(children: [
                    ElevatedButton(
                        child:
                            Text('쇼핑', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {shopping = true, print(shopping)}),
                    ElevatedButton(
                        child: Text('실내여행지',
                            style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {indoor = true, print(indoor)}),
                    ElevatedButton(
                        child:
                            Text('시티투어', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {city = true, print(city)}),
                    ElevatedButton(
                        child:
                            Text('지역축제', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {festival = true, print(festival)}),
                    ElevatedButton(
                        child:
                            Text('전통한옥', style: TextStyle(color: Colors.black)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () => {
                              traditional_house = true,
                              print(traditional_house)
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
