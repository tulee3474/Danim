import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'main.dart';

class User {
  final String fullName;
  final String company;
  final int age;

  User({
    required this.fullName,
    required this.company,
    required this.age,
  });

  // User.fromJson(Map<String, dynamic> json)
  //     : cid = json['full_name'],
  //       title = json['company'],
  //       number = json['age'];

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'company': company,
        'age': age,
      };
}

class Point {
  final String name;
  final double xCoordinate;
  final double yCoordinate;

  Point({
    required this.name,
    required this.xCoordinate,
    required this.yCoordinate,
  });

  // User.fromJson(Map<String, dynamic> json)
  //     : cid = json['full_name'],
  //       title = json['company'],
  //       number = json['age'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'xCoordinate': xCoordinate,
        'yCoordinate': yCoordinate,
      };
}

void fb_write_user() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User userModel =
      User(fullName: 'John Doe', company: "Stokes and Sons", age: 42);
  users.add(userModel.toJson());
}

void fb_write_point(city, name, latitude, longitude) {
  //CollectionReference points = FirebaseFirestore.instance.collection('points');

  //덮어쓰기
  // FirebaseFirestore.instance.collection('points').doc(city).set({
  //   'name': name,
  //   'xCoordinate': xCoordinate,
  //   'yCoordinate': yCoordinate,
  // }, SetOptions(merge: false));

  //합쳐쓰기
  FirebaseFirestore.instance.collection(city).doc(name).set({
    'latitude': latitude,
    'longitude': longitude,
  }, SetOptions(merge: true));
}

class ReadController extends GetxController {
  final db = FirebaseFirestore.instance;
  //var data;
  Future<List<double>> fb_read_point(city, name) async {
    var data = await db.collection(city).doc(name).get();
    // final docRef = db.collection(city).doc(name);
    // docRef.get().then(
    //   (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
    print(data.data());

    double data1 = data.data()!['latitude'];
    double data2 = data.data()!['longitude'];

    List<double> dataList = [data1, data2];

    print(dataList);

    // 컬렉션 전체 읽어오기, 문서 이름은 안알려주고 값만 넣은 2차원 배열 형태. x좌표 y좌표 상관없이 오름차순 정렬해줌....ㅠ
    // db.collection(city).get().then(
    //       (value) => print(value.docs.map((doc) => doc.data()).toList()),
    //       onError: (e) => print("Error completing: $e"),
    //     );
    return dataList;
  }
}
