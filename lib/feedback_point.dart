import 'package:flutter/material.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';

Future<void> feedback(
    city, traveledPlaceList, selectList, starPoint, review) async {
  //traveledPlaceList List<String>

  List<Place> pointingPlaceList = [];

  var read = ReadController();
  for (int f = 0; f < traveledPlaceList.length; f++) {
    Place readData;
    try {
      readData = await read.fb_read_one_place(city, traveledPlaceList[f]);
      pointingPlaceList.add(readData);
    } catch (e) {
      continue;
    }
  }

  //각 성향 점수 += (별점-4) * 선택 유무
  for (int i = 0; i < pointingPlaceList.length; i++) {
    Place place = pointingPlaceList[i];
    for (int y = 0; y < selectList[0].length; y++) {
      place.partner[y] += (starPoint - 4) * selectList[0][y] as int;
      if (place.partner[y] < 0) {
        place.partner[y] = 0;
      } else if (place.partner[y] > 100) {
        place.partner[y] = 100;
      }
    }
    for (int y = 0; y < selectList[1].length; y++) {
      place.concept[y] += (starPoint - 4) * selectList[1][y] as int;
      if (place.concept[y] < 0) {
        place.concept[y] = 0;
      } else if (place.concept[y] > 100) {
        place.concept[y] = 100;
      }
    }
    for (int y = 0; y < selectList[2].length; y++) {
      place.play[y] += (starPoint - 4) * selectList[2][y] as int;
      if (place.play[y] < 0) {
        place.play[y] = 0;
      } else if (place.play[y] > 100) {
        place.play[y] = 100;
      }
    }
    for (int y = 0; y < selectList[3].length; y++) {
      place.tour[y] += (starPoint - 4) * selectList[3][y] as int;
      if (place.tour[y] < 0) {
        place.tour[y] = 0;
      } else if (place.tour[y] > 100) {
        place.tour[y] = 100;
      }
    }
    for (int y = 0; y < selectList[4].length; y++) {
      place.season[y] += (starPoint - 4) * selectList[4][y] as int;
      if (place.season[y] < 0) {
        place.season[y] = 0;
      } else if (place.season[y] > 100) {
        place.season[y] = 100;
      }
    }
    fb_write_place(
        city,
        place.name,
        place.latitude,
        place.longitude,
        place.takenTime,
        place.popular,
        place.partner,
        place.concept,
        place.play,
        place.tour,
        place.season);
  }

  FirebaseFirestore.instance.collection("사용자 리뷰").doc(city).update({
    '리뷰': FieldValue.arrayUnion([review])
  });
}

void fb_write_place(city, name, latitude, longitude, takenTime, popular,
    partner, concept, play, tour, season) {
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
    'takenTime': takenTime,
    'popular': popular,
    'partner': partner,
    'concept': concept,
    'play': play,
    'tour': tour,
    'season': season,
  }, SetOptions(merge: true));

  //관광지 목록에 이름 작성
  // FirebaseFirestore.instance.collection(city).doc("관광지목록").update({
  //   "관광지": FieldValue.arrayUnion([name]),
  // });

  print("파이어베이스 업로드 완료");
}