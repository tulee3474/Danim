class Place {
  String name = ""; //_는 private의 의미
  int time = 0;
  double latitude = 0.00; //위도
  double longitude = 0.00; //경도
  int popular = 0; //인기관광지 척도 - 조회수기반
  List<int> partner = List.generate(7, (index) => 0);
  //0: 혼자 여행, 1: 커플여행 2:우정여행 3:가족여행 4:효도여행 5:어린자녀와 6:반려견과
  List<int> concept = List.generate(5, (index) => 0);
  //0: 힐링 1: 에너지틱 2:배움이 있는 3:여유로운 4:맛있는
  List<int> play = List.generate(6, (index) => 0);
  //0: 레저스포츠 1: 문화시설 2: 사진 3: 이색체험 4:문화체험 5: 역사
  List<int> tour = List.generate(11, (index) => 0);
  //0: 바다 1:산 2:자연  3:트레킹 4:드라이브코스 5:산책
  //6: 쇼핑 7:실내여행지  8:시티투어 9:지역 축제 10:전통한옥
  List<int> season = List.generate(4, (index) => 0);
  //0: 봄 1:여름 2:가을 3:겨울

  // Place({
  //   required this.name,
  //   required this.latitude,
  //   required this.longitude,
  //   required this.popular,
  //   required this.partner,
  //   required this.concept,
  //   required this.play,
  //   required this.tour,
  //   required this.season,
  // });
  Place(
      this.name,
      this.time,
      this.latitude,
      this.longitude,
      this.popular,
      this.partner,
      this.concept,
      this.play,
      this.tour,
      this.season,
      );

  Place.from(Place bestPath);

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'popular': popular,
    'partner': partner,
    'concept': concept,
    'play': play,
    'tour': tour,
    'season': season,
  };
}
