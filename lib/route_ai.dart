// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'firebase_read_write.dart';
import 'map.dart';

List<Place> placeList = []; //장소 리스트, 전역 변수

class RouteAI {
  //Step 1. Data Loading
  data_loading(city) async {
    List<Place> readData;

    placeList = []; //한번 초기화하고 넣자

    var read = ReadController();

    readData = await read.fb_read_all_place(city);

    placeList.addAll(readData);
  }

  //Step 2. Initialization
  List<Place> initialize_greedy(selectList, firstPlace, timeLimit) {
    int numPlace = placeList.length;

    List<Place> path = [];
    path.add(firstPlace);
    int totalTime = 0; //총 여행 시간

    int startIndex = -1;

    //Iteratively Connect nearest cities
    for (int i = 1; i < numPlace; i++) {
      List<int> sum = List<int>.filled(numPlace, 0); //각 관광지의 점수 합

      //각 관광지별 계산하기
      for (int n = 0; n < numPlace; n++) {
        int time = 600;
        //time = timeCalculate(path[i-1].name, placeList[n].name); - 시간계산 함수 - 시간계산 dart에서 함수 호출, 시간 리턴

        //자동차 여행일 경우 시간에 대한 가중치 줄여줌.
        // if (carTravel) {
        //   time *= 0.8;
        // }
        //각 성향 점수 * 가중치 * 선택 유무 sum에 +해주기
        sum[n] += place_point(selectList, placeList[n]);

        sum[n] += placeList[n].popular as int; //인기관광지 지표 포함하기
        sum[n] -= time as int; // - 시간 계산
      }

      //sort해서 다음 목적지 고르기, sort해서 그 인덱스 번호를 알아와야함. 그래야 Place리스트에서 쓸 수 있음.
      List sumCopy = new List.from(sum);
      sumCopy.sort();

      for (int q = 0; q < numPlace; q++) {
        startIndex = sum.indexOf(sumCopy[q]); //다음 목적지의 Index
        //path에 placeList[startIndex]가 없을 경우 다음 목적지 확정 (sort결과 최고의 목적지)
        if (path.indexOf(placeList[startIndex]) == -1) {
          break;
        }
      }

      path.add(placeList[startIndex]);

      //첫 관광지에서의 소요시간
      if (i == 0) {
        totalTime += path[0].takenTime;
      } else {
        //totalTime += timeCalculate(path[i-1].name, path[i].name); - 이동 시간 계산해서 +해주기
        totalTime += path[i].takenTime; // 관광지에서 소요시간
      }

      if (totalTime > timeLimit) {
        //예정된 여행 시간만큼의 일정이 채워졌다면 반복 종료
        break;
      }
      //만약, 숙소를 골라두었을 경우, 마지막 장소로 가는 소요시간까지 생각하기
      // if (chooseHouse) {
      //   if (totalTime + timeCalculate(path[-1].name, house) >
      //       timeLimit) {
      //     break;
      //   }
      // }
    }
    return path;
  }

  int place_point(selectList, targetPlace) {
    int sum = 0;

    //각 성향 카테고리별 가중치, weight[5]는 popular, 인기관광지 점수
    List weight = [1, 2, 2, 1, 1, 1];

    //각 성향 점수 * 가중치 * 선택 유무
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < selectList[x].length; y++) {
        if (x == 0) {
          sum += targetPlace.partner[y] * weight[x] * selectList[x][y] as int;
        } else if (x == 1) {
          sum += targetPlace.concept[y] * weight[x] * selectList[x][y] as int;
        } else if (x == 2) {
          sum += targetPlace.play[y] * weight[x] * selectList[x][y] as int;
        } else if (x == 3) {
          sum += targetPlace.tour[y] * weight[x] * selectList[x][y] as int;
        } else if (x == 4) {
          sum += targetPlace.season[y] * weight[x] * selectList[x][y] as int;
        } else {
          print("알 수 없는 에러");
        }
      }
    }

    return sum;
  }

  //Step 3. Searching a path
  List<Place> two_opts(selectList, path) {
    int iterations = 20; //2-opts 시도 횟수

    List<Place> bestPath = new List.from(path);
    int bestCost = 0;

    //판단 기준은 시간 제외, place_point의 합으로 한다.
    //제한 시간은 동일하니, 동선이 좋다면 관광지 수가 많아 점수가 높을 것
    for (int i = 0; i < bestPath.length; i++) {
      bestCost += place_point(selectList, bestPath[i]);
    }

    for (int i = 0; i < iterations; i++) {
      List<Place> newPath = new List.from(bestPath);

      int idx1 = Random().nextInt(bestPath.length);
      int idx2 = Random().nextInt(bestPath.length);

      //1. 이미 있는 코스에서 2개를 바꾼다.
      if (i % 2 == 0) {
        Place temp;
        temp = Place.from(newPath[idx1]);

        newPath.remove(idx1);
        newPath.insert(idx1, Place.from(newPath[idx2]));

        newPath.remove(idx2);
        newPath.insert(idx2, temp);

        //newPath[idx1] = Place.from(newPath[idx2]);
        //newPath[idx2] = Place.from(temp);

      }
      //2. 관광지 하나를 새 관광지로 바꾼다. - 안할까 고민중
      //근데 path 하나의 관광지 수가 많지는 않을텐데, 하는게 맞나?
      //아예 랜덤으로 하면, 너무 멀리있는 관광지랑 바뀔 수도 있음
      //현재 cost시스템이 시간을 고려 안하기 때문
      else {
        // newPath[idx1] =
        //     new Place.from(placeList[Random().nextInt(placeList.length)]);
        //하게된다면, 기존 path와 중복 여부 체크도 추가할 것.
      }

      int newCost = 0;
      for (int i = 0; i < newPath.length; i++) {
        newCost += place_point(selectList, newPath[i]);
      }

      if (newCost < bestCost) {
        bestPath = new List.from(newPath);
        bestCost = newCost;
      }
    }

    return bestPath;
  }

  List<Place> hill_climbing(path, selectList) {
    int StopRepeat = 3; //개선 여부에 따른 HC 횟수 조절

    bool kOptContinue = true;

    int kOptCheck = 0;

    List<Place> bestPath = two_opts(selectList, path);

    int bestCost = 0;

    //판단 기준은 시간 제외, place_point의 합으로 한다.
    //제한 시간은 동일하니, 동선이 좋다면 관광지 수가 많아 점수가 높을 것
    for (int i = 0; i < bestPath.length; i++) {
      bestCost += place_point(selectList, bestPath[i]);
    }

    while (kOptContinue) {
      List<Place> newPath = two_opts(selectList, path);

      int newCost = 0;

      for (int i = 0; i < newPath.length; i++) {
        newCost += place_point(selectList, newPath[i]);
      }

      // 2-opts를 통해 개선이 일어났다면, 기존 path와 교체
      if (newCost < bestCost) {
        bestPath = new List.from(newPath);
        bestCost = newCost;
        kOptCheck = 0; //개선이 일어났으면 k_opt_check를 0으로 초기화하여 다시 카운트
      } else {
        kOptCheck += 1;
      }

      //개선이 StopRepeat만큼 일어나지 않으면 반복문 종료
      if (kOptCheck >= StopRepeat) {
        kOptContinue = false;
      }
    }

    return bestPath;
  }

  //main part
  Future<List<List<Place>>> route_search(
      city, selectList, timeLimit, numPreset) async {
    // await안쓰면 이 함수 따로 돌리고 넘어가서, placeList에 원소 안넣은 상태로 코드돌림
    //await data_loading(city);
    //이거 map.dart에서 실행하는거로 일단 바꿈.!!!!!!!!!!!!!!!!!!!!

    List<List<Place>> pathList = []; //path의 List,관광지의 List의 List

    List<int> point = [];

    //모든 관광지의 시간을 제외한 point를 탐색
    for (int i = 0; i < placeList.length; i++) {
      point.add(place_point(selectList, placeList[i]));
    }

    //점수를 기준으로 sort해서 시작 관광지를 numPreset만큼 추출
    List pointCopy = new List.from(point);
    pointCopy.sort();

    Place firstPlace;
    for (int i = 0; i < numPreset; i++) {
      int index = point.indexOf(pointCopy[i]); //출발지의 Index
      firstPlace = placeList[index];
      //초기 path 만들기
      List<Place> initializePath =
          initialize_greedy(selectList, firstPlace, timeLimit);

      //초기 path 개선 - Hill-Climbing으로
      List<Place> improvedPath = hill_climbing(initializePath, selectList);
      //pathList에 저장
      pathList.add(improvedPath);
    }

    //Map map = const Map();

    for (int i = 0; i < numPreset; i++) {
      //map.addMarker(pathList[i]);
      //addPloy(pathList[i]);

    }

    return pathList;
  }
}

class RouteAIPage extends StatelessWidget {
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
                  var ai = RouteAI(); //RouteAI 클래스 생성

                  List<List<Place>> read_data;

                  //임시 selectList
                  List selectList = [
                    [0, 1, 0, 0, 0, 0, 0],
                    [0, 1, 0, 1],
                    [0, 1, 0, 0, 1, 0],
                    [0, 1, 0, 1, 0, 1, 1, 0, 1],
                    [0, 1, 0, 0]
                  ];

                  read_data = await ai.route_search("제주도", selectList, 600, 2);
                  print("route_search함수 실행 후 리턴");
                  print(read_data);

                  for (int i = 0; i < read_data.length; i++) {
                    print("코스");
                    for (int j = 0; j < read_data[i].length; j++) {
                      print(read_data[i][j].name);
                    }
                    print("---------------------------");
                  }

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
