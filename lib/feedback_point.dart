import 'package:flutter/material.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';

class Feedback {
  Future<void> feedback(
      city, traveledPlaceList, selectList, starPoint, review) async {
    //traveledPlaceList List<String>

    List<Place> placeList = [];

    var read = ReadController();
    for (int f = 0; f < traveledPlaceList.length; f++) {
      Place readData = await read.fb_read_one_place(city, traveledPlaceList[f]);
      placeList.add(readData);
    }

    //각 성향 점수 += (별점-4) * 선택 유무
    for (int i = 0; i < placeList.length; i++) {
      Place place = placeList[i];
      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < selectList[x].length; y++) {
          if (x == 0) {
            place.partner[y] += (starPoint - 4) * selectList[x][y] as int;
          } else if (x == 1) {
            place.concept[y] += (starPoint - 4) * selectList[x][y] as int;
          } else if (x == 2) {
            place.play[y] += (starPoint - 4) * selectList[x][y] as int;
          } else if (x == 3) {
            place.tour[y] += (starPoint - 4) * selectList[x][y] as int;
          } else if (x == 4) {
            place.season[y] += (starPoint - 4) * selectList[x][y] as int;
          } else {
            print("알 수 없는 에러");
          }
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
}
