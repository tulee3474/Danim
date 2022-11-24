// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'firebase_read_write.dart';
import 'map.dart';
import 'route.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;

String apiKEY = 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI';
String placeURL =
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?';

Future<LatLng> getLocation(String place) async {
  LatLng latLng;
  http.Response response = await http.get(
    Uri.parse(
        '${placeURL}input=$place&inputtype=textquery&fields=formatted_address,name,geometry&key=$apiKEY'),
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

List<Place> placeList = []; //장소 리스트, 전역 변수, 원본
List<Place> placeListCopy = []; //장소 리스트, 전역 변수, n일차 코스를 위함.
//path에 들어간 Place들은 제거하는 리스트
List count = [0, 0, 0, 0, 0]; //selectList 선택 개수 저장 배열

int qqq = 0;
int www = 0;
bool ffff = true;

class RouteAI {
  //Step 1. Data Loading
  data_loading(city) async {
    List<Place> readData;

    placeList = []; //한번 초기화하고 넣자
    placeListCopy = []; //한번 초기화하고 넣자

    var read = ReadController();

    readData = await read.fb_read_all_place(city);

    placeList.addAll(readData);
    placeListCopy.addAll(readData);
  }

  //Step 2. Initialization
  Future<List<Place>> initialize_greedy(
      selectList, firstPlace, fixedPlaceList, timeLimit) async {
    List<Place> path = [];
    path.add(firstPlace);

    //placeListCopy에서는 제거
    placeListCopy.removeWhere((item) => item.name == firstPlace.name);

    //fixedPlaceList가 있을 경우
    if (fixedPlaceList.length > 0) {
      for (int i = 0; i < fixedPlaceList.length; i++) {
        path.add(fixedPlaceList[i]);
        placeListCopy
            .removeWhere((item) => item.name == fixedPlaceList[i].name);
      }
    }

    int numPlace = placeListCopy.length;

    int totalTime = 0; //총 여행 시간

    int startIndex = -1;

    //만약, 숙소를 골라두었을 경우, 마지막 장소로 가는 소요시간까지 생각하기
    if (firstPlace.name != '더미' && timeLimit > 2) {
      timeLimit -= 1;
    }

    //Iteratively Connect nearest cities
    for (int i = path.length; i < numPlace; i++) {
      List<int> sum = List<int>.filled(numPlace, 0); //각 관광지의 점수 합

      //각 관광지별 계산하기
      for (int n = 0; n < placeListCopy.length; n++) {
        //자동차 여행일 경우 거리에 대한 가중치 줄여줌.
        // if (carTravel) {
        //   time *= 0.8;
        // }

        //첫 관광지가 이미 path에 있으므로 beforePlace에 null 넣는 예외처리 안해줘도 된다.
        //각 성향 점수 * 가중치 * 선택 유무 sum에 +해주기

        sum[n] += place_point(selectList, path[i - 1], placeListCopy[n]);
      }

      //sort해서 다음 목적지 고르기, sort해서 그 인덱스 번호를 알아와야함. 그래야 Place리스트에서 쓸 수 있음.
      List sumCopy = new List.from(sum);
      sumCopy.sort();

      for (int q = 0; q < numPlace; q++) {
        startIndex = sum.indexOf(sumCopy[q]); //다음 목적지의 Index
        //path에 placeListCopy[startIndex]가 없을 경우 다음 목적지 확정 (sort결과 최고의 목적지)
        if (path.indexOf(placeListCopy[startIndex]) == -1) {
          break;
        }
      }

      //path에 관광지 추가
      path.add(Place.clone(placeListCopy[startIndex]));

      //placeListCopy에서는 제거
      placeListCopy
          .removeWhere((item) => item.name == placeListCopy[startIndex].name);
      numPlace -= 1;

      //첫 관광지에서의 소요시간
      if (i == 0) {
        totalTime += path[0].takenTime;
      } else {
        //totalTime += timeCalculate(path[i-1].name, path[i].name); - 이동 시간 계산해서 +해주기
        //distance해서 거리 비율 시간 계산
        totalTime += path[i].takenTime; // 관광지에서 소요시간
      }

      if (totalTime > timeLimit) {
        //예정된 여행 시간만큼의 일정이 채워졌다면 반복 종료
        break;
      }
    }
    return path;
  }

  int place_point(selectList, beforePlace, targetPlace) {
    int sum = 0;

    //각 성향 카테고리별 가중치, weight[5]는 popular, 인기관광지 점수
    List weight = [15, 15, 15, 15, 15, 0.3];
    List listSum = [0, 0, 0, 0, 0];
    //각 성향 점수 * 가중치 * 선택 유무
    // for (int x = 0; x < 5; x++) {
    //   for (int y = 0; y < selectList[x].length; y++) {
    //     if (x == 0) {
    //       listSum[0] +=
    //           targetPlace.partner[y] * weight[x] * selectList[x][y] as int;
    //     } else if (x == 1) {
    //       listSum[1] +=
    //           targetPlace.concept[y] * weight[x] * selectList[x][y] as int;
    //     } else if (x == 2) {
    //       listSum[2] +=
    //           targetPlace.play[y] * weight[x] * selectList[x][y] as int;
    //     } else if (x == 3) {
    //       listSum[3] +=
    //           targetPlace.tour[y] * weight[x] * selectList[x][y] as int;
    //     } else if (x == 4) {
    //       listSum[4] +=
    //           targetPlace.season[y] * weight[x] * selectList[x][y] as int;
    //     } else {
    //       print("알 수 없는 에러");
    //     }
    //   }
    //   if (count[x] > 0) {
    //     sum += (listSum[x] / count[x]).ceil() as int;
    //   }
    // }

    for (int y = 0; y < selectList[0].length; y++) {
      listSum[0] +=
          targetPlace.partner[y] * weight[0] * selectList[0][y] as int;
    }
    for (int y = 0; y < selectList[1].length; y++) {
      listSum[1] +=
          targetPlace.concept[y] * weight[1] * selectList[1][y] as int;
    }
    for (int y = 0; y < selectList[2].length; y++) {
      listSum[2] += targetPlace.play[y] * weight[2] * selectList[2][y] as int;
    }
    for (int y = 0; y < selectList[3].length; y++) {
      listSum[3] += targetPlace.tour[y] * weight[3] * selectList[3][y] as int;
    }
    for (int y = 0; y < selectList[4].length; y++) {
      listSum[4] += targetPlace.season[y] * weight[4] * selectList[4][y] as int;
    }
    for (int x = 0; x < 5; x++) {
      if (count[x] > 0) {
        sum += (listSum[x] / count[x]).ceil() as int;
      }
    }

    sum += (targetPlace.popular * weight[5].ceil()) as int; //인기관광지 지표 포함하기

    if (beforePlace != null) {
      //더미는 스킵
      if (targetPlace.latitude == 0.0 || beforePlace.latitude == 0.0) {
        return sum;
      }
      double latDiff = targetPlace.latitude - beforePlace.latitude;
      double longDiff = targetPlace.longitude - beforePlace.longitude;

      double distance = sqrt(latDiff * latDiff + longDiff * longDiff) * 25000;

      sum -= distance.toInt(); // - 거리 계산

      if (distance > 3000) {
        qqq += 1;
      } else {
        www += 1;
      }
    }

    return sum;
  }

  //Step 3. Searching a path
  List<Place> two_opts(path, fixedPlaceList, selectList, finishPath) {
    int iterations = 5000; //2-opts 시도 횟수

    //fixedPlaceList가 없을 경우 2배로 시도 횟수를 늘린다.
    // if (fixedPlaceList.length == 0) {
    //   iterations = iterations * 2;
    // }

    List<Place> bestPath = new List.from(path);
    int bestPoint = 0;

    //판단 기준은 place_point의 합으로 한다.
    bestPoint += place_point(selectList, null, bestPath[0]);
    for (int i = 1; i < bestPath.length; i++) {
      bestPoint += place_point(selectList, bestPath[i - 1], bestPath[i]);
    }

    for (int i = 0; i < iterations; i++) {
      List<Place> newPath = new List.from(bestPath);
      var addPlace;
      var removePlace;
      bool flag3 = false;
      int idx1 = -1;
      int idx2 = -1;
      if (bestPath.length > 2) {
        idx1 = Random().nextInt(bestPath.length - 1) + 1;
        idx2 = Random().nextInt(bestPath.length - 1) + 1;
      } else {
        break;
      }

      while (idx1 == idx2 && (bestPath.length > 2)) {
        idx2 = Random().nextInt(bestPath.length - 1) + 1;
      }
      //idx1, 2 순서 정렬
      if (idx1 > idx2) {
        int idx3 = idx1;
        idx1 = idx2;
        idx2 = idx3;
      }

      //1. 관광지 하나를 새 관광지로 바꾼다. - 모든 관광지를 갈 경우 안함.
      if (i % 3 == 0 &&
          (placeList.length > newPath.length) &&
          placeListCopy.length > 0) {
        var temp;
        bool flag = true;
        int flag2 = 0;
        flag3 = false;
        while (true) {
          int a = Random().nextInt(placeListCopy.length);
          Place temp2 = Place.clone(placeListCopy[a]);

          for (int j = 1; j < newPath.length; j++) {
            if (temp2.name == newPath[j].name) {
              flag = false; //같은 이름이 있으면, 반복하여 다른 Place찾음
            }
          }
          if (flag) {
            temp = Place.clone(temp2);
            break;
          } else {
            flag2 += 1;
          }
          flag = true; //이거땜에 많이 헤멨었는데, 까먹지 말고 초기화할것!
          //만약을 대비
          if (flag2 > 10) {
            flag3 = true;
            break;
          }
        }
        if (flag3) {
          continue;
        }
        addPlace = null;
        addPlace = Place.clone(temp);
        removePlace = null;
        removePlace = Place.clone(newPath[idx1]);

        //fixedPlaceList가 있는데, removePlace가 이 안에 있다면, break
        bool flag4 = false;
        for (int k = 0; k < fixedPlaceList.length; k++) {
          if (removePlace.name == fixedPlaceList[k].name) {
            flag4 = true; //같은 이름이 있으면, continue;
          }
        }

        if (flag4) {
          //제거할 Place가 fixedPlace여서 continue합니다.
          continue;
        }

        newPath
            .removeWhere((item) => item.name == Place.clone(removePlace).name);
        //혹시모르니까, 추가전에 한번 더 없애줌
        newPath.removeWhere((item) => item.name == Place.clone(addPlace).name);
        if (idx1 >= newPath.length) {
          newPath.add(Place.clone(addPlace));
        } else {
          newPath.insert(idx1, Place.clone(addPlace));
        }
      }
      //2. 이미 있는 코스에서 2개를 바꾼다.
      else {
        Place temp;
        Place temp2;
        temp = Place.clone(newPath[idx1]);
        temp2 = Place.clone(newPath[idx2]);
        newPath.removeWhere((item) => item.name == newPath[idx1].name);
        newPath.removeWhere((item) => item.name == newPath[idx2 - 1].name);
        if (idx1 >= newPath.length) {
          newPath.add(Place.clone(temp2));
        } else {
          newPath.insert(idx1, Place.clone(temp2));
        }
        if (idx2 >= newPath.length) {
          newPath.add(Place.clone(temp));
        } else {
          newPath.insert(idx2, Place.clone(temp));
        }
      }

      int newPoint = 0;

      newPoint += place_point(selectList, null, newPath[0]);
      for (int n = 1; n < newPath.length; n++) {
        newPoint += place_point(selectList, newPath[n - 1], newPath[n]);
      }

      if (newPoint >= bestPoint) {
        bestPath = new List.from(newPath);
        if (i % 3 == 0 &&
            (placeList.length > newPath.length) &&
            placeListCopy.length > 0 &&
            flag3 == false &&
            (addPlace.name != removePlace.name)) {
          placeListCopy.removeWhere((item) => item.name == addPlace.name);
          //혹시 모르니까 추가 전에 한번 더 없애줌
          placeListCopy.removeWhere((item) => item.name == removePlace.name);
          if (addPlace.name != removePlace.name) {
            placeListCopy.add(Place.clone(removePlace));
          }
          //혹시 모르니까 한번 더 없애줌
          placeListCopy.removeWhere((item) => item.name == addPlace.name);

          //에러를 도저히 못찾아서 그냥 매번 새롭게 만듦.
          placeListCopy = [];
          placeListCopy = new List.from(placeList);
          for (int q = 0; q < bestPath.length; q++) {
            placeListCopy.removeWhere((item) => item.name == bestPath[q].name);
          }
          for (int q = 0; q < finishPath.length; q++) {
            placeListCopy
                .removeWhere((item) => item.name == finishPath[q].name);
          }
        }
        bestPoint = newPoint;
      }
    }

    return bestPath;
  }

  List<Place> hill_climbing(
      path, fixedPlaceList, selectList, finishPath, house, timeLimit) {
    int StopRepeat = 5; //개선 여부에 따른 HC 횟수 조절
    int StopRepeat2 = 2000; //너무 많이 반복되는 것 방지

    //fixedPlaceList가 없을 경우 2배로 시도
    // if (fixedPlaceList.length == 0) {
    //   StopRepeat *= 2;
    //   StopRepeat2 *= 2;
    // }

    bool kOptContinue = true;

    int kOptCheck = 0;
    int kOptCheck2 = 0;

    List<Place> bestPath =
        two_opts(path, fixedPlaceList, selectList, finishPath);

    int bestPoint = 0;

    //판단 기준은 시간 제외, place_point의 합으로 한다.
    //제한 시간은 동일하니, 동선이 좋다면 관광지 수가 많아 점수가 높을 것
    bestPoint += place_point(selectList, null, bestPath[0]);
    for (int i = 1; i < bestPath.length; i++) {
      bestPoint += place_point(selectList, bestPath[i - 1], bestPath[i]);
    }

    while (kOptContinue) {
      List<Place> newPath =
          two_opts(path, fixedPlaceList, selectList, finishPath);

      int newPoint = 0;

      newPoint += place_point(selectList, null, newPath[0]);
      for (int i = 1; i < newPath.length; i++) {
        newPoint += place_point(selectList, newPath[i - 1], newPath[i]);
      }

      // 2-opts를 통해 개선이 일어났다면, 기존 path와 교체
      if (newPoint > bestPoint) {
        bestPath = new List.from(newPath);
        bestPoint = newPoint;
        kOptCheck = 0; //개선이 일어났으면 k_opt_check를 0으로 초기화하여 다시 카운트
        kOptCheck2 += 1;
      } else {
        kOptCheck += 1;
        kOptCheck2 += 1;
      }
      // print("kOptCheck2");
      // print(kOptCheck2);
      //개선이 StopRepeat만큼 일어나지 않으면 반복문 종료

      if (kOptCheck >= StopRepeat || kOptCheck2 >= StopRepeat2) {
        kOptContinue = false;
      }
    }

    //이게 true가 되면 fixedPlace가 맨 앞으로 이동한 것이라서, 경로 최적화 다시
    bool courseFlag = true;

    //시간 계산해서 뒷부분 짤라야 함
    int totalTime = 0;
    //100번 해봐도 못빠져나가면 그대로 리턴해버림
    for (int r = 0; r < 100; r++) {
      totalTime = 0;
      for (int t = 0; t < bestPath.length; t++) {
        totalTime += bestPath[t].takenTime;
      }

      //코스의 길이가 길수록 이동시간도 길어짐
      //길이에 비례하여 timeLimit를 줄임
      //이 수치는 차후에 조정할 것!!
      if (totalTime > timeLimit - bestPath.length * 30) {
        int aaa = bestPath.length;
        Place popPlace = bestPath.removeLast();

        //fixedPlaceList가 있을 경우
        if (fixedPlaceList.length > 0) {
          for (int d = 0; d < fixedPlaceList.length; d++) {
            //만약 pop된 Place가 fixedPlaceList에 있을 경우
            if (popPlace.name == fixedPlaceList[d].name) {
              //bestPath의 맨 앞으로 이동시킨다.

              courseFlag = true;

              //숙소가 없을 경우
              if (house == null) {
                if (bestPath[0].name == '더미') {
                  bestPath.insert(1, Place.clone(popPlace));
                } else {
                  bestPath.insert(0, Place.clone(popPlace));
                }
              }
              //숙소가 없을 경우
              else {
                if (bestPath[0].name == house.name) {
                  bestPath.insert(1, Place.clone(popPlace));
                } else {
                  bestPath.insert(0, Place.clone(popPlace));
                }
              }

              break;
            }
          }
        } else if (aaa - bestPath.length != 1) {
          print("알 수 없는 에러");
        }
      } else {
        break;
      }
      if (r == 99) {
        print("HC 마무리 과정 중, 뺄 수 있는 Place가 없습니다.");
        print('totalTime : ' + totalTime.toString());
        print('timeLimit : ' + timeLimit.toString());
        print(bestPath.length);
        print(bestPath[0].name);
      }
    }

    //fixedPlace가 맨 앞으로 이동해서, 경로 최적화 다시
    if (courseFlag) {
      //먼저 현재 코스의 거리합을 계산한다
      double bestSum = 100000000.0;

      //그 후, full search를 통해 최적 경로를 찾는다. 갯수 적어서 ㄱㅊ을듯
      //시간복잡도 O(n!)일거임 아마?
      List<Place> tempPath = new List.from(bestPath);
      Place tempPlace = Place.clone(tempPath[0]);

      tempPath.removeWhere((item) => item.name == tempPath[0].name);
      if (house != null) {
        tempPath.add(house);
      }
      //첫번째 관광지는 고정이니까
      course_full_search(tempPath, [tempPlace], house);

      for (int x = 0; x < corDis.length; x++) {
        if (corDis[x].length == 0) {
          print("경로최적화 중 알 수 없는 에러 발생");
          break;
        }
        if (house != null) {
          //마지막게 숙소가 아니면 건너뜀. 첫번째건 짜피 고정
          if (corDis[x].last.name != house.name) {
            continue;
          }
        }
        double sum = 0.0;

        for (int y = 0; y < corDis[x].length - 1; y++) {
          if (corDis[x][y].latitude == 0.0) {
            continue; //이 경우는 house가 없어서, firstPlace가 더미인경우밖에없음
          }
          double latDiff = corDis[x][y].latitude - corDis[x][y + 1].latitude;
          double longDiff = corDis[x][y].longitude - corDis[x][y + 1].longitude;

          double dis = sqrt(latDiff * latDiff + longDiff * longDiff);
          sum += dis;
        }
        // 코스 길이 합이 짧아졌다면 기존 코스와 교체
        if (sum < bestSum) {
          bestPath = new List.from(corDis[x]);

          bestSum = sum;
        }
      }
    }
    corDis = [];
    return bestPath;
  }

  bool sadsad = true;
  List<List<Place>> corDis = [];

  course_full_search(
      List<Place> placeList, List<Place> selectList, Place house) {
    //selectList가 모든 관광지를 가져온 경우
    if (placeList.length == 0) {
      corDis.add(List.from(selectList));
    }
    //재귀 하향 탐색? selectList에 관광지 하나씩 넘겨가면서
    for (int i = 0; i < placeList.length; i++) {
      selectList.add(placeList[i]);
      placeList.removeWhere((item) => item.name == placeList[i].name);
      course_full_search(placeList, selectList, house);
      placeList.insert(i, selectList.last);
      int temp = selectList.length;
      selectList.removeWhere((item) => item.name == selectList.last.name);
      //2개 이상인 경우는 house가 빠지는 경우밖에 없음
      if (temp - selectList.length > 1 && house != null) {
        selectList.insert(0, house);
      }
    }
  }

  //main part
  Future<List<List<List<Place>>>> route_search(city, house, fixedPlaceNameList,
      fixedPlaceDayList, selectList, timeLimitArray, numPreset, nDay) async {
    // await안쓰면 이 함수 따로 돌리고 넘어가서, placeList에 원소 안넣은 상태로 코드돌림

    //selectList 선순회
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < selectList[x].length; y++) {
        if (selectList[x][y] == 1) count[x] += 1;
      }
    }

    //path의 List,관광지의 List의 List, 날짜별로 한번 더 쪼갠것임
    //pathList[프리셋넘버][n일차넘버][n번째관광지]
    List<List<List<Place>>> pathList = [];

    List<int> point = [];

    List<Place> fixedPlaceList = [];

    int timeLimit = 0;
    List time = [];

    //시간 지정 안했을 경우 하루당 10시간
    if (timeLimitArray == null) {
      timeLimit = 10 * 60;
      for (int d = 0; d < nDay; d++) {
        time.add(timeLimit);
      }
    }
    //시간 지정 했을 경우
    else {
      //당일치기여행이면, timeLimitArray[0]~timeLimitArray[1]만 생각하면 된다.
      if (nDay == 1) {
        timeLimit = (timeLimitArray[1] as int) - (timeLimitArray[0] as int) - 3;
        timeLimit = timeLimit * 60;
        time.add(timeLimit);
      }
      //timeLimit 계산해주기 - timeLimitArray[0] = 첫날 시작시간
      //timeLimitArray[1] = 마지막 날 끝나는 시간
      //3시간 이동시간으로 빼주기
      else {
        timeLimit = 20 - (timeLimitArray[0] as int);
        timeLimit = timeLimit * 60;
        time.add(timeLimit);
        for (int d = 0; d < nDay - 2; d++) {
          timeLimit = 10 * 60;
          time.add(timeLimit);
        }
        timeLimit = (timeLimitArray[1] as int) - 8;
        timeLimit = timeLimit * 60;
        time.add(timeLimit);
      }
    }

    Place firstPlace = Place.clone(dummy);

    for (int i = 0; i < numPreset; i++) {
      List<Place> finishPath = [];

      List<List<Place>> tempPath = [];

      for (int d = 0; d < nDay; d++) {
        //숙소를 지정해뒀을 경우
        if (house != null) {
          firstPlace = Place.clone(house);
        }
        //숙소를 지정해두지 않았을 경우
        else {
          //모든 관광지의 시간을 제외한 point를 탐색
          point.add(place_point(selectList, null, placeListCopy[0]));
          for (int i = 1; i < placeListCopy.length; i++) {
            point.add(place_point(selectList, null, placeListCopy[i]));
          }
          //점수를 기준으로 sort해서 시작 관광지를 numPreset * day만큼 추출
          List pointCopy = new List.from(point);
          pointCopy.sort();
          int index = point.indexOf(pointCopy[i]); //출발지의 Index
          firstPlace = Place.clone(placeListCopy[index]);
        }

        fixedPlaceList = [];

        if (fixedPlaceNameList.length > 0) {
          var read = ReadController();
          for (int f = 0; f < fixedPlaceNameList.length; f++) {
            //fixedPlaceDayList의 원소가 d+1(n일차)와 같을때만
            if (fixedPlaceDayList[f] == d + 1) {
              // Place readData =
              //     await read.fb_read_one_place(city, fixedPlaceNameList[f]);
              LatLng tmp = await getLocation(fixedPlaceNameList[f]);
              double lat = tmp.latitude; //좌표읽어오기

              double long = tmp.longitude; //좌표읽어오기
              Place readData = Place(
                  fixedPlaceNameList[f],
                  lat,
                  long,
                  60,
                  0,
                  [0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0]);
              fixedPlaceList.add(readData);
              placeListCopy.removeWhere((item) => item.name == readData.name);
            }
          }
        }

        //초기 path 만들기
        List<Place> initializePath = await initialize_greedy(
            selectList, firstPlace, fixedPlaceList, time[d]);

        //초기 path 개선 - Hill-Climbing으로
        List<Place> improvedPath = hill_climbing(initializePath, fixedPlaceList,
            selectList, finishPath, house, time[d]);

        //path 맨뒤에 숙소 추가
        // if (house != null) {
        //   improvedPath.add(Place.clone(house));
        // }

        finishPath = new List.from(finishPath)..addAll(improvedPath);

        placeListCopy = [];
        placeListCopy = new List.from(placeList);
        for (int q = 0; q < finishPath.length; q++) {
          placeListCopy.removeWhere((item) => item.name == finishPath[q].name);
        }

        //i번째 프리셋 pathList에 추가
        tempPath.add(improvedPath);
      }

      pathList.add(tempPath);
      placeListCopy = [];
      placeListCopy = new List.from(placeList);
    }

    print(qqq);
    print(www);
    print("위 두개는 거리 지표가 어느정도 효과인지 알아보기 위함");
    count = [0, 0, 0, 0, 0]; //전역변수 다시 초기화
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

                  //List<List<Place>> read_data;

                  //임시 selectList
                  List selectList = [
                    [0, 1, 0, 0, 0, 0, 0],
                    [0, 1, 0, 1],
                    [0, 1, 0, 0, 1, 0],
                    [0, 1, 0, 1, 0, 1, 1, 0, 1],
                    [0, 1, 0, 0]
                  ];

                  var read = ReadController();

                  User read_data = await read.fb_read_user("docCodeTest123");
                  print(read_data.name);
                  print(read_data.travelList);
                  print(read_data.placeNumList);
                  print(read_data.traveledPlaceList);
                  print(read_data.eventNumList);
                  print(read_data.eventList[0]);
                  print(read_data.eventList[0].title);
                  print(read_data.diaryList);

                  // read_data =
                  //     await ai.route_search("제주도", selectList, 600, 2, 2);

                  // for (int i = 0; i < read_data.length; i++) {
                  //   print("코스");
                  //   for (int j = 0; j < read_data[i].length; j++) {
                  //     print(read_data[i][j].name);
                  //   }
                  //   print("---------------------------");
                  // }

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
