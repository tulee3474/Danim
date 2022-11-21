import "package:http/http.dart" as http;
import 'dart:convert';

String tourIDURL='http://apis.data.go.kr/B551011/KorService/searchKeyword?serviceKey=';
String tourAPIKey='cpdbSNlDtCFQ3vwzm3k4z7MGFhllBYrChw7LONQgQL%2BV69GVfExYYQgM0%2BRapks5ABcZSke4TeBbmN%2FCINcfLQ%3D%3D';
String tourInfoURL='http://apis.data.go.kr/B551011/KorService/detailCommon?serviceKey=';

Future<int> getTourID(String placeName) async{
  int contentID=0;
  http.Response response = await http.get(Uri.parse(
      '$tourIDURL$tourAPIKey&_type=json&MobileOS=AND&numOfRows=10&MobileApp=directions5&arrange=B&keyword=$placeName'
  ),
  );
  if (response.statusCode < 200 || response.statusCode > 400) {
    contentID = 0; // Error 반환
  } else {
    String responseData = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(responseData);
    int isExist=responseBody["response"]["body"]["totalCount"];
    if(isExist==0) {
      contentID=0;
    }
    else {
      var list = responseBody["response"]["body"]["items"]["item"][0];
      contentID = int.parse(list["contentid"]);
    }
  }
  return contentID;
}

Future<String> getTourInfo(String placeName) async {
  int contentID=await getTourID(placeName);
  String contentOverview='';
  if (contentID==0) {
    contentOverview='정보가 없습니다.';
  }
  else {
    http.Response response = await http.get(Uri.parse(
        '$tourInfoURL$tourAPIKey&_type=json&MobileOS=AND&numOfRows=10&pageNo=1&MobileApp=directions5&contentId=$contentID&overviewYN=Y'
    ),
    );
    if (response.statusCode < 200 || response.statusCode > 400) {
      contentOverview='정보가 없습니다.'; // Error 반환
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["response"]["body"]["items"]["item"][0];
      //toursite=responseBody.toString();
      contentOverview = list["overview"];
    }
  }
  return contentOverview;
}

