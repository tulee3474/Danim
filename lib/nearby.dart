import "package:http/http.dart" as http;
import 'dart:convert';

String kakaoURL = 'https://dapi.kakao.com/v2/local/search/keyword.json?';
String apiKEY = '8b345cc6f29414a95b06e3ea40b1dfca';

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
}

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
