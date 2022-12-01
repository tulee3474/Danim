import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:naver_map_plugin/naver_map_plugin.dart';

String kakaoURL = 'https://dapi.kakao.com/v2/local/search/keyword.json?';
String apiKEY = '8b345cc6f29414a95b06e3ea40b1dfca';
List<String> compareList=[];

class Restaurant {
  String restName = '';
  String restCategory = '';
  double restLat = 0.0;
  double restLong = 0.0;

  Restaurant(this.restName, this.restCategory, this.restLat, this.restLong);

  void printRest() {
    print('$restName $restCategory $restLat $restLong \n');
  }
}

class Cafe {
  String cafeName = '';
  String cafeCategory = '';
  double cafeLat = 0.0;
  double cafeLong = 0.0;

  Cafe(this.cafeName, this.cafeCategory, this.cafeLat, this.cafeLong);

  void printCafe() {
    print('$cafeName $cafeCategory $cafeLat $cafeLong \n');
  }
}

class Accommodation {
  String accoName = '';
  String accoCategory = '';
  double accoLat = 0.0;
  double accoLong = 0.0;

  Accommodation(this.accoName, this.accoCategory, this.accoLat, this.accoLong);

  void printCafe() {
    print('$accoName $accoCategory $accoLat $accoLong \n');
  }
}

List<Restaurant> restaurantList = [];
List<Cafe> cafeList = [];
List<Accommodation> accommodationList = [];
Future<List<Restaurant>> getRestaurant(double lat1,double lng1, double lat2, double lng2) async {
  restaurantList.clear();
  List<LatLng> restLatLen = [];
  restLatLen.add(LatLng(lat1,lng1));
  restLatLen.add(LatLng((lat1+lat2)/2,(lng1+lng2)/2));
  restLatLen.add(LatLng(lat2,lng2));
  for (int j=0;j<3;j++) {
    http.Response response = await http.get(Uri.parse(
        "https://dapi.kakao.com/v2/local/search/keyword.json?y=${restLatLen[j].latitude}&x=${restLatLen[j].longitude}&radius=3000&query=맛집&category_group_code=FD6&size=10&page=1"
    ), headers: {"Authorization": "KakaoAK 3c1aba3b633e1d6804e9c59f68ac6601"}
    );
    if (response.statusCode < 200 || response.statusCode > 400) {
      String err = response.statusCode.toString();
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["documents"];
      compareList.clear();
      for (int i=0;i<list.length;i++) {
        String restaurantName=list[i]["place_name"];
        if (!compareList.contains(restaurantName)) {
          compareList.add(restaurantName);
          String restaurantCategory=list[i]["category_name"];
          double restaurantLat=double.parse(list[i]["y"]);
          double restaurantLong=double.parse(list[i]["x"]);
          restaurantList.add(Restaurant(restaurantName, restaurantCategory, restaurantLat, restaurantLong));
        }
      }
    }
  }
  return restaurantList;
}

Future<List<Cafe>> getCafe(double lat1,double lng1, double lat2, double lng2) async {
  cafeList.clear();
  List<LatLng> cafeLatLen = [];
  cafeLatLen.add(LatLng(lat1,lng1));
  cafeLatLen.add(LatLng((lat1+lat2)/2,(lng1+lng2)/2));
  cafeLatLen.add(LatLng(lat2,lng2));
  for (int j=1;j<3;j++) {
    http.Response response = await http.get(Uri.parse(
        "https://dapi.kakao.com/v2/local/search/keyword.json?y=${cafeLatLen[j].latitude}&x=${cafeLatLen[j].longitude}&radius=3000&query=맛집&category_group_code=CE7&size=10&page=1"
    ), headers: {"Authorization": "KakaoAK 3c1aba3b633e1d6804e9c59f68ac6601"}
    );
    if (response.statusCode < 200 || response.statusCode > 400) {
      String err = response.statusCode.toString();
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["documents"];

      for (int i = 0; i < list.length; i++) {
        String cafeName = list[i]["place_name"];
        String cafeCategory = list[i]["category_name"];
        double cafeLat = double.parse(list[i]["y"]);
        double cafeLong = double.parse(list[i]["x"]);
        cafeList.add(Cafe(cafeName, cafeCategory, cafeLat, cafeLong));
      }
    }
  }
  return cafeList;
}
/*
void getRestaurant(double lat, double lng) async {
  for (int j = 1; j < 6; j++) {
    http.Response response = await http.get(
        Uri.parse(
            "${kakaoURL}y=$lat&x=$lng&radius=3000&query=맛집&category_group_code=FD6&size=10&page=$j"),
        headers: {"Authorization": "KakaoAK $apiKEY"});
    if (response.statusCode < 200 || response.statusCode > 400) {
      String err = response.statusCode.toString();
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["documents"];

      for (int i = 0; i < list.length; i++) {
        String restaurantName = list[i]["place_name"];
        String restaurantCategory = list[i]["category_name"];
        double restaurantLat = double.parse(list[i]["y"]);
        double restaurantLong = double.parse(list[i]["x"]);
        restaurantList.add(Restaurant(
            restaurantName, restaurantCategory, restaurantLat, restaurantLong));
      }
    }
  }
}

void getCafe(double lat, double lng) async {
  for (int j = 1; j < 6; j++) {
    http.Response response = await http.get(
        Uri.parse(
            "${kakaoURL}y=$lat&x=$lng&radius=3000&query=맛집&category_group_code=CE7&size=10&page=$j"),
        headers: {"Authorization": "KakaoAK $apiKEY"});
    if (response.statusCode < 200 || response.statusCode > 400) {
      String err = response.statusCode.toString();
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["documents"];

      for (int i = 0; i < list.length; i++) {
        String cafeName = list[i]["place_name"];
        String cafeCategory = list[i]["category_name"];
        double cafeLat = double.parse(list[i]["y"]);
        double cafeLong = double.parse(list[i]["x"]);
        cafeList.add(Cafe(cafeName, cafeCategory, cafeLat, cafeLong));
      }
    }
  }
}*/

void getAccommodation(double lat, double lng) async {
  for (int j = 1; j < 6; j++) {
    http.Response response = await http.get(
        Uri.parse(
            "https://dapi.kakao.com/v2/local/search/category.json?category_group_code=AD5&y=$lat&x=$lng&radius=3000&size=10&page=$j"),
        headers: {"Authorization": "KakaoAK $apiKEY"});
    if (response.statusCode < 200 || response.statusCode > 400) {
      String err = response.statusCode.toString();
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      var list = responseBody["documents"];

      for (int i = 0; i < list.length; i++) {
        String accommodationName = list[i]["place_name"];
        String accommodationCategory = list[i]["category_name"];
        double accommodationLat = double.parse(list[i]["y"]);
        double accommodationLong = double.parse(list[i]["x"]);
        accommodationList.add(Accommodation(accommodationName,
            accommodationCategory, accommodationLat, accommodationLong));
      }
    }
  }
}
