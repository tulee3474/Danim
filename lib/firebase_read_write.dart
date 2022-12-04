import 'dart:async';

import 'package:danim/calendar_view.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';
import 'package:danim/src/post.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';

//import 'main.dart';

//Write하는 부분
void fb_write_diary(docCode, diaryList) {
  FirebaseFirestore.instance.collection('Users').doc(docCode).set({
    // 'name': name,
    // 'travelList': travelList,
    // 'placeNumList': placeNumList,
    // 'traveledPlaceList': traveledPlaceList,
    // 'eventNumList': eventNumList,
    //'eventStringList': eventStringList,
    'diaryList': diaryList,
  }, SetOptions(merge: true));
}

void fb_write_user(docCode, name, travelList, placeNumList, traveledPlaceList,
    eventNumList, selectList, eventList, diaryList) {
  var data2;
  CalendarEventData temp;

  List<String> eventStringList = [];
  print(docCode);
  FirebaseFirestore.instance.collection('Users').doc(docCode).set({
    'name': name,
    'travelList': travelList,
    'placeNumList': placeNumList,
    'traveledPlaceList': traveledPlaceList,
    'eventNumList': eventNumList,
    //'eventStringList': eventStringList,
    'diaryList': diaryList,
  }, SetOptions(merge: true));

  String title;

  for (int i = 0; i < eventList.length; i++) {
    title = eventList[i].title;
    if (eventList[i].title == "이동" || eventList[i].title == "식사시간") {
      if (i < 10) {
        title = eventList[i].title + i.toString() + '!';
      } else if (i < 100) {
        title = eventList[i].title + i.toString() + '@';
      } else if (i < 1000) {
        title = eventList[i].title + i.toString() + '#';
      } else {
        title = eventList[i].title + i.toString() + '%';
      }
    }
    eventStringList.add(title);
    int date = eventList[i].date.year * 10000 +
        eventList[i].date.month * 100 +
        eventList[i].date.day;
    int startTime = eventList[i].startTime.year * 1000000 +
        eventList[i].startTime.month * 10000 +
        eventList[i].startTime.day * 100 +
        eventList[i].startTime.hour;
    int endTime = eventList[i].endTime.year * 1000000 +
        eventList[i].endTime.month * 10000 +
        eventList[i].endTime.day * 100 +
        eventList[i].endTime.hour;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(docCode)
        .collection('event' + travelList.length.toString())
        .doc(eventStringList[i])
        .set({
      'title': eventStringList[i],
      //위도, 경도 추가 - write부분
      'latitude': eventList[i].latitude,
      'longitude': eventList[i].longitude,
      'date': date,
      'description': eventList[i].description,
      'startTime': startTime,
      'endTime': endTime,
    }, SetOptions(merge: true));
  }

  for (int i = 0; i < travelList.length; i++) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(docCode)
        .collection('selectList')
        .doc(i.toString())
        .set({
      'partner': selectList[0],
      'concept': selectList[1],
      'play': selectList[2],
      'tour': selectList[3],
      'season': selectList[4],
    }, SetOptions(merge: true));
  }

  FirebaseFirestore.instance.collection('Users').doc(docCode).set({
    'eventStringList': eventStringList,
  }, SetOptions(merge: true));
}

void fb_update_place(city, name, latitude, longitude, takenTime, popular,
    partner, concept, play, tour, season) {
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
}

void fb_add_place(city, name, latitude, longitude, takenTime, popular, partner,
    concept, play, tour, season) {
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
    'takenTime': takenTime,
    'popular': popular,
    'partner': partner,
    'concept': concept,
    'play': play,
    'tour': tour,
    'season': season,
  }, SetOptions(merge: true));

  //관광지 목록에 이름 작성
  FirebaseFirestore.instance.collection(city).doc("관광지목록").update({
    "관광지": FieldValue.arrayUnion([name]),
  });

  print("파이어베이스 업로드 완료");
}

void fb_add_post(postTitle, postNum, postWriter, postContent) {
  //합쳐쓰기
  FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).set({
    'postTitle': postTitle,
    'postNum': postNum,
    'postWriter': postWriter,
    'commentList': [], //첫 작성이니까
    'commentWriterList': [], //첫 작성이니까
    'recommendList': [], //첫 작성이니까
    'recommendNum': 0,
    'postContent': postContent,
  }, SetOptions(merge: true));

  //관광지 목록에 이름 작성
  FirebaseFirestore.instance.collection("커뮤니티").doc("게시물목록").update({
    "게시물": FieldValue.arrayUnion([postTitle]),
  });

  print("파이어베이스 업로드 완료");
}

void fb_add_comment(postTitle, comment, commentWriterList) {
  FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).update({
    "commentList": FieldValue.arrayUnion([comment]),
  });
  FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).set({
    'commentWriterList': commentWriterList,
  }, SetOptions(merge: true));
  // 아래 방법은 중복 토큰이 저장 안됨. 할 수 없이 리스트 전체를 저장함
  // FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).update({
  //   "commentWriterList": FieldValue.arrayUnion([commentWriter]),
  // });

  print("파이어베이스 업로드 완료");
}

void fb_add_recommend(postTitle, recommender, recommendNum) {
  FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).update({
    "recommendList": FieldValue.arrayUnion([recommender]),
  });

  FirebaseFirestore.instance.collection("커뮤니티").doc(postTitle).set({
    'recommendNum': recommendNum + 1,
  }, SetOptions(merge: true));

  print("파이어베이스 업로드 완료");
}

//Read하는 부분
class ReadController extends GetxController {
  final db = FirebaseFirestore.instance;
  //var data;

  Future<User> fb_read_other_course(String docCodeNum) async {
    //docCodeNum - docCode/num 형태, num은 1, 2, 3, 4 - event뒤의 숫자와 동일

    List<String> tempList = docCodeNum.split('/');

    print(tempList);

    String docCode = tempList[0];

    print(tempList[1]);

    // int docNum = tempList[1] as int; - 에러남, 이유는 모름
    int docNum = int.parse(tempList[1]);

    docNum -= 1; //num은 1, 2, 3, 4 형태니까 하나빼준다

    var data = await db.collection('Users').doc(docCode).get();

    String name = data.data()!['name'] as String;

    //Error: Expected a value of type 'List<int>', but got one of type 'List<dynamic>'
    //위 에러 때문에 하나식 일일히 형변환함. 리스트를 통으로 형변환하면 에러

    List<dynamic> travelList2 = data.data()!['travelList'];
    List<String> travelList = [];
    travelList.add(travelList2[docNum] as String);

    List<dynamic> placeNumList2 = data.data()!['placeNumList'];
    List<int> placeNumList = [];
    placeNumList.add(placeNumList2[docNum] as int);

    //갯수 계산 - traveledPlaceList때문
    int placeDocIndex = 0;
    for (int i = 0; i < docNum; i++) {
      placeDocIndex += placeNumList2[i] as int;
    }

    List<dynamic> traveledPlaceList2 = data.data()!['traveledPlaceList'];
    List<String> traveledPlaceList = [];
    for (int i = placeDocIndex; i < placeDocIndex + placeNumList[0]; i++) {
      traveledPlaceList.add(traveledPlaceList2[i] as String);
    }

    List<dynamic> eventNumList2 = data.data()!['eventNumList'];
    List<int> eventNumList = [];
    eventNumList.add(eventNumList2[docNum] as int);

    var data2;
    List<dynamic> eventStringList2 = data.data()!['eventStringList'];

    CalendarEventData temp;

    List<CalendarEventData> eventList = [];

    //갯수 계산 - eventList때문
    int eventDocIndex = 0;
    for (int j = 0; j < docNum; j++) {
      eventDocIndex += eventNumList2[j] as int;
    }

    for (int i = 0; i < eventNumList[0]; i++) {
      data2 = await db
          .collection('Users')
          .doc(docCode)
          .collection('event' + (docNum + 1).toString()) //여기서만 다시 +1
          .doc(eventStringList2[i + eventDocIndex] as String)
          .get();

      String title = data2.data()!['title'] as String;

      if (title.substring(title.length - 1) == '!') {
        title = title.substring(0, title.length - 2);
      } else if (title.substring(title.length - 1) == '@') {
        title = title.substring(0, title.length - 3);
      } else if (title.substring(title.length - 1) == '#') {
        title = title.substring(0, title.length - 4);
      } else if (title.substring(title.length - 1) == '%') {
        title = title.substring(0, title.length - 5);
      }
      List<int> date = parseDate(data2.data()!['date'] as int);

      List<int> startTime = parseTime(data2.data()!['startTime'] as int);
      List<int> endTime = parseTime(data2.data()!['endTime'] as int);
      //위도, 경도 추가 - read부분
      var latitude = data2.data()!['latitude'];
      //print('asdf $latitude');
      var longitude = data2.data()!['longitude'];
      temp = CalendarEventData(
        title: title,
        date: DateTime(date[0], date[1], date[2]),

        //위도, 경도 추가 - read부분
        latitude: latitude as double,
        longitude: longitude,
        event: Event(title: title),

        description: data2.data()!['description'] as String,
        startTime:
            DateTime(startTime[0], startTime[1], startTime[2], startTime[3]),
        endTime: DateTime(endTime[0], endTime[1], endTime[2], endTime[3]),
      );
      eventList.add(temp);
    }

    List<dynamic> diaryList2 = data.data()!['diaryList'];
    List<String> diaryList = [];
    diaryList.add(diaryList2[docNum] as String);

    User userData = User(docCode, name, travelList, placeNumList,
        traveledPlaceList, eventNumList, eventList, diaryList);

    return userData;
  }

  Future<User> fb_read_user(docCode) async {
    var data = await db.collection('Users').doc(docCode).get();

    String name = data.data()!['name'] as String;

    //Error: Expected a value of type 'List<int>', but got one of type 'List<dynamic>'
    //위 에러 때문에 하나식 일일히 형변환함. 리스트를 통으로 형변환하면 에러

    List<dynamic> travelList2 = data.data()!['travelList'];
    List<String> travelList = [];
    for (int i = 0; i < travelList2.length; i++) {
      travelList.add(travelList2[i] as String);
    }

    List<dynamic> placeNumList2 = data.data()!['placeNumList'];
    List<int> placeNumList = [];
    for (int i = 0; i < placeNumList2.length; i++) {
      placeNumList.add(placeNumList2[i] as int);
    }

    List<dynamic> traveledPlaceList2 = data.data()!['traveledPlaceList'];
    List<String> traveledPlaceList = [];
    for (int i = 0; i < traveledPlaceList2.length; i++) {
      traveledPlaceList.add(traveledPlaceList2[i] as String);
    }

    List<dynamic> eventNumList2 = data.data()!['eventNumList'];
    List<int> eventNumList = [];
    for (int i = 0; i < eventNumList2.length; i++) {
      eventNumList.add(eventNumList2[i] as int);
    }

    var data2;
    List<dynamic> eventStringList2 = data.data()!['eventStringList'];

    CalendarEventData temp;

    List<CalendarEventData> eventList = [];
    for (int j = 0; j < travelList.length; j++) {
      int iSave = 0;
      for (int i = 0; i < eventNumList[j]; i++) {
        data2 = await db
            .collection('Users')
            .doc(docCode)
            .collection('event' + (j + 1).toString())
            .doc(eventStringList2[i + iSave] as String)
            .get();

        String title = data2.data()!['title'] as String;

        if (title.substring(title.length - 1) == '!') {
          title = title.substring(0, title.length - 2);
        } else if (title.substring(title.length - 1) == '@') {
          title = title.substring(0, title.length - 3);
        } else if (title.substring(title.length - 1) == '#') {
          title = title.substring(0, title.length - 4);
        } else if (title.substring(title.length - 1) == '%') {
          title = title.substring(0, title.length - 5);
        }
        List<int> date = parseDate(data2.data()!['date'] as int);

        List<int> startTime = parseTime(data2.data()!['startTime'] as int);
        List<int> endTime = parseTime(data2.data()!['endTime'] as int);
        //위도, 경도 추가 - read부분
        var latitude = data2.data()!['latitude'];
        //print('asdf $latitude');
        var longitude = data2.data()!['longitude'];
        temp = CalendarEventData(
          title: title,
          date: DateTime(date[0], date[1], date[2]),

          //위도, 경도 추가 - read부분
          latitude: latitude as double,
          longitude: longitude,
          event: Event(title: title),

          description: data2.data()!['description'] as String,
          startTime:
              DateTime(startTime[0], startTime[1], startTime[2], startTime[3]),
          endTime: DateTime(endTime[0], endTime[1], endTime[2], endTime[3]),
        );
        eventList.add(temp);
      }
      iSave += eventNumList[j];
    }

    //경도출력확인
    print('fb_위도: ${eventList[0].latitude}');

    List<dynamic> diaryList2 = data.data()!['diaryList'];
    List<String> diaryList = [];
    for (int i = 0; i < diaryList2.length; i++) {
      diaryList.add(diaryList2[i] as String);
    }

    User userData = User(docCode, name, travelList, placeNumList,
        traveledPlaceList, eventNumList, eventList, diaryList);

    return userData;
  }

  Future<List<List<int>>> fb_read_user_selectList(docCode, index) async {
    List<List<int>> selectList = [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0]
    ];

    print(index);
    var data;
    data = await db
        .collection('Users')
        .doc(docCode)
        .collection('selectList')
        .doc(index.toString())
        .get();

    List<dynamic> partner2 = data.data()!['partner'];
    for (int i = 0; i < partner2.length; i++) {
      selectList[0][i] = partner2[i] as int;
    }
    List<dynamic> concept2 = data.data()!['concept'];
    for (int i = 0; i < concept2.length; i++) {
      selectList[1][i] = concept2[i] as int;
    }
    List<dynamic> play2 = data.data()!['play'];
    for (int i = 0; i < play2.length; i++) {
      selectList[2][i] = play2[i] as int;
    }
    List<dynamic> tour2 = data.data()!['tour'];
    for (int i = 0; i < tour2.length; i++) {
      selectList[3][i] = tour2[i] as int;
    }
    List<dynamic> season2 = data.data()!['season'];
    for (int i = 0; i < season2.length; i++) {
      selectList[4][i] = season2[i] as int;
    }
    return selectList;
  }

  Future<List<Place>> fb_read_all_place(city) async {
    List<Place> data = [];

    List<String> placeList = await fb_read_place_list(city) as List<String>;

    for (int i = 0; i < placeList.length; i++) {
      Place read_data = await fb_read_one_place(city, placeList[i]);
      data.add(read_data);
    }
    // for (int i = 0; i < data.length; i++) {
    //   print(data[i].name);
    //   print(data[i].latitude);
    // }

    return data;
  }

  Future<List> fb_read_place_list(city) async {
    var data = await db.collection(city).doc("관광지목록").get();

    List<String> placeList = [];
    for (int i = 0; i < data.data()!['관광지'].length; i++) {
      placeList.add(data.data()!['관광지'][i]);
    }
    return placeList;
  }

  Future<Place> fb_read_one_place(city, name) async {
    var data = await db.collection(city).doc(name).get();

    double latitude = data.data()!['latitude'] as double;
    double longitude = data.data()!['longitude'] as double;
    int popular = data.data()!['popular'] as int;
    int takenTime = data.data()!['takenTime'] as int;

    //Error: Expected a value of type 'List<int>', but got one of type 'List<dynamic>'
    //위 에러 때문에 하나식 일일히 형변환함. 리스트를 통으로 형변환하면 에러
    List<dynamic> partner2 = data.data()!['partner'];
    List<int> partner = [];
    for (int i = 0; i < partner2.length; i++) {
      partner.add(partner2[i] as int);
    }
    List<dynamic> concept2 = data.data()!['concept'];
    List<int> concept = [];
    for (int i = 0; i < concept2.length; i++) {
      concept.add(concept2[i] as int);
    }
    List<dynamic> play2 = data.data()!['play'];
    List<int> play = [];
    for (int i = 0; i < play2.length; i++) {
      play.add(play2[i] as int);
    }
    List<dynamic> tour2 = data.data()!['tour'];
    List<int> tour = [];
    for (int i = 0; i < tour2.length; i++) {
      tour.add(tour2[i] as int);
    }
    List<dynamic> season2 = data.data()!['season'];
    List<int> season = [];
    for (int i = 0; i < season2.length; i++) {
      season.add(season2[i] as int);
    }

    Place placedata = Place(name, latitude, longitude, takenTime, popular,
        partner, concept, play, tour, season);

    return placedata;
  }

  //커뮤니티 Read
  Future<List> fb_read_all_post() async {
    List<Post> data = [];

    List<String> postList = await fb_read_post_list() as List<String>;

    for (int i = 0; i < postList.length; i++) {
      Post read_data = await fb_read_one_post(postList[i]);
      data.add(read_data);
    }

    return data;
  }

  Future<List> fb_read_post_list() async {
    var data = await db.collection("커뮤니티").doc("게시물목록").get();

    List<String> postList = [];
    for (int i = 0; i < data.data()!['게시물'].length; i++) {
      postList.add(data.data()!['게시물'][i]);
    }
    return postList;
  }

  Future<Post> fb_read_one_post(name) async {
    var data = await db.collection('커뮤니티').doc(name).get();

    String postTitle = data.data()!['postTitle'] as String;
    int postNum = data.data()!['postNum'] as int;
    String postWriter = data.data()!['postWriter'] as String;
    int recommendNum = data.data()!['recommendNum'] as int;
    String postContent = data.data()!['postContent'] as String;

    //Error: Expected a value of type 'List<int>', but got one of type 'List<dynamic>'
    //위 에러 때문에 하나식 일일히 형변환함. 리스트를 통으로 형변환하면 에러
    List<dynamic> commentList2 = data.data()!['commentList'];
    List<String> commentList = [];
    for (int i = 0; i < commentList2.length; i++) {
      commentList.add(commentList2[i] as String);
    }
    List<dynamic> commentWriterList2 = data.data()!['commentWriterList'];
    List<String> commentWriterList = [];
    for (int i = 0; i < commentWriterList2.length; i++) {
      commentWriterList.add(commentWriterList2[i] as String);
    }

    List<dynamic> recommendList2 = data.data()!['recommendList'];
    List<String> recommendList = [];
    for (int i = 0; i < recommendList2.length; i++) {
      recommendList.add(recommendList2[i] as String);
    }

    Post postData = Post(
      postTitle,
      postNum,
      postWriter,
      commentList,
      commentWriterList,
      recommendList,
      recommendNum,
      postContent,
    );

    return postData;
  }

  List<int> parseDate(date) {
    List<int> returnData = [];

    returnData.add(date ~/ 10000); //year
    int index1 = date % 10000;
    returnData.add(index1 ~/ 100); //month
    int index2 = date % 100;
    returnData.add(index2); //day

    return returnData;
  }

  List<int> parseTime(time) {
    List<int> returnData = [];

    returnData.add(time ~/ 1000000); //year
    int index1 = time % 1000000;
    returnData.add(index1 ~/ 10000); //month
    int index2 = time % 10000;
    returnData.add(index2 ~/ 100); //day
    int index3 = time % 100;
    returnData.add(index3); //time

    return returnData;
  }
}
