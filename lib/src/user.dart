import '../model/event.dart';
import 'package:danim/calendar_view.dart';

class User {
  String docCode = ""; // 로그인 API로 얻어 온 사용자별 코드
  String name = ""; // 사용자 이름
  List<String> travelList = []; // 여행다닌 city저장, placeNumList랑 1:1 대응
  List<int> placeNumList = []; // 각 여행에서 몇개의 관광지를 여행 다녔는지
  List<String> traveledPlaceList = []; //여행다녔던 관광지들 1차원 배열
  List<int> eventNumList = []; // 각 여행에서 몇개의 이벤트가 있는지
  List<CalendarEventData> eventList = []; // 이벤트 1차원 배열
  List<String> diaryList = []; // 일기 - 텍스트만, travelList랑 1:1 대응

  User(
    this.docCode,
    this.name,
    this.travelList,
    this.placeNumList,
    this.traveledPlaceList,
    this.eventNumList,
    this.eventList,
    this.diaryList,
  );

  // User.fromJson(Map<String, dynamic> json)
  //     : cid = json['full_name'],
  //       title = json['company'],
  //       number = json['age'];

  Map<String, dynamic> toJson() => {
        'docCode': docCode,
        'name': name,
        'travelList': travelList,
        'placeNumList': placeNumList,
        'traveledPlaceList': traveledPlaceList,
        'eventNumList': eventNumList,
        'eventList': eventList,
        'diaryList': diaryList,
      };
}
