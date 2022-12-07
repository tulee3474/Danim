

// 자차 이동시간 리스트 생성
import 'package:danim/src/place.dart';

import '../route.dart';

Future<List<List<int>>> createDrivingTimeList (List<List<Place>> preset) async {

  List<List<int>> drivingTimeList = [
    for(int i=0; i<preset.length; i++)
      []
  ];
  int movingTime = 0;

  //자차 이동시간 받아오기

  for (int i = 0; i < preset.length; i++) {
    for (int j = 0; j < preset[i].length - 1; j++) {
      movingTime = (await getDrivingDuration(
          preset[i][j].latitude, preset[i][j].longitude,
          preset[i][j + 1].latitude, preset[i][j + 1].longitude));
      drivingTimeList[i].add(movingTime);
    }
  }


  return await drivingTimeList;
}

//대중교통 이동시간 리스트 생성
Future<List<List<int>>> createTransitTimeList( List<List<Place>> preset ) async {

  TransitTime transitTime;
  List<List<int>> transitTimeList = [
    for(int i=0; i<preset.length; i++)
      []
  ];

  for(int i=0; i<preset.length; i++){

    for(int j=0; j<preset[i].length-1; j++){

      transitTime = (await getTransitDuration(preset[i][j].latitude, preset[i][j].longitude,
          preset[i][j + 1].latitude, preset[i][j + 1].longitude));
      transitTimeList[i].add(transitTime.transitDuration);

    }

  }


  return transitTimeList;

}



//대중교통 이동 방법 리스트 생성
Future<List<List<String>>> createTransitStepsList( List<List<Place>> preset ) async {

  TransitTime transitTime;
  List<List<String>> transitStepsList = [
    for(int i=0; i<preset.length; i++)
      []
  ];

  for(int i=0; i<preset.length; i++){

    for(int j=0; j<preset[i].length-1; j++){

      transitTime = (await getTransitDuration(preset[i][j].latitude, preset[i][j].longitude,
          preset[i][j + 1].latitude, preset[i][j + 1].longitude));
      transitStepsList[i].add(transitTime.transitSteps);

    }

  }


  return transitStepsList;

}
