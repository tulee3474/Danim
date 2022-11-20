import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'auto_add.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

String name = ''; //관광지명
double lat = 0.0;
double long = 0.0;
int time = 0; // 소요시간
int popular = 0; // popular
var attribute; // 성향점수

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final cName = TextEditingController();
  final cLat = TextEditingController();
  final cLong = TextEditingController();
  final cTime = TextEditingController();
  final cPopular = TextEditingController();
  final c00 = TextEditingController();
  final c01 = TextEditingController();
  final c02 = TextEditingController();
  final c03 = TextEditingController();
  final c04 = TextEditingController();
  final c05 = TextEditingController();
  final c06 = TextEditingController();
  final c10 = TextEditingController();
  final c11 = TextEditingController();
  final c12 = TextEditingController();
  final c14 = TextEditingController();
  final c20 = TextEditingController();
  final c21 = TextEditingController();
  final c22 = TextEditingController();
  final c23 = TextEditingController();
  final c24 = TextEditingController();
  final c25 = TextEditingController();
  final c30 = TextEditingController();
  final c31 = TextEditingController();
  final c34 = TextEditingController();
  final c35 = TextEditingController();
  final c40 = TextEditingController();
  final c41 = TextEditingController();
  final c42 = TextEditingController();
  final c43 = TextEditingController();
  final c44 = TextEditingController();
  final c50 = TextEditingController();
  final c51 = TextEditingController();
  final c52 = TextEditingController();
  final c53 = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // myController1.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    cName.dispose();
    cLat.dispose();
    cLong.dispose();
    cTime.dispose();
    cPopular.dispose();
    c00.dispose();
    c01.dispose();
    c02.dispose();
    c03.dispose();
    c04.dispose();
    c05.dispose();
    c06.dispose();
    c10.dispose();
    c11.dispose();
    c12.dispose();
    c14.dispose();
    c20.dispose();
    c21.dispose();
    c22.dispose();
    c23.dispose();
    c24.dispose();
    c25.dispose();
    c30.dispose();
    c31.dispose();
    c34.dispose();
    c35.dispose();
    c40.dispose();
    c41.dispose();
    c42.dispose();
    c43.dispose();
    c44.dispose();
    c50.dispose();
    c51.dispose();
    c52.dispose();
    c53.dispose();

    super.dispose();
  }

  void _printLatestValue() {
    //함수가 하는 일 .
    // print('Second text field: ${myController.text}');
  }

  void _name(String ename) {
    name = ename;
  }

  void _lat(double eLat) {
    lat = eLat;
  }

  void _long(double eLong) {
    long = eLong;
  }

  void _time(int etime) {
    time = etime;
  }

  void _popular(int epopular) {
    popular = epopular;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("관광지 성향점수 입력"),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AutoAddPage()),
              );
              print('ElevatedButton - onPressed');
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AutoAddPage()),
              );
              print('ElevatedButton - onLongPress');
            },
            // button 스타일은 여기서 작성한다.
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Color.fromARGB(255, 47, 0, 255),
            ),
            child: const Text('자동 추가'),
          ),
        ],
      ),
      body: Center(
          child: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
              width: 200.0,
              child: TextField(
                  controller: cName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '관광지명')))
        ]),

        Row(children: <Widget>[
          Container(
              width: 200.0,
              child: TextField(
                  controller: cLat,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Latitude')))
        ]),

        Row(children: <Widget>[
          Container(
              width: 200.0,
              child: TextField(
                  controller: cLong,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Longitude')))
        ]),

        Row(children: <Widget>[
          Container(
              width: 200.0,
              child: TextField(
                  controller: cTime,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '소요시간')))
        ]),

        //관광지명 입력

        Row(children: <Widget>[
          Container(
              width: 200.0,
              child: TextField(
                  controller: cPopular,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Popular')))
        ]),

        //Popular 입력

        Row(children: <Widget>[
          Container(
              width: 60.0,
              child: TextField(
                  controller: c00,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '혼자여행'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c01,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '커플여행'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c02,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '우정여행'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c03,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '가족여행'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c04,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '효도여행'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c05,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '어린자녀'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c06,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '반려견과')))
        ]),

        // 반려견과,,

        Row(children: <Widget>[
          Container(
              width: 60.0,
              child: TextField(
                  controller: c10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '힐링'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c11,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '에너지'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c12,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '배움'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c14,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '맛있는')))
        ]),

        // 맛있는,,

        Row(children: <Widget>[
          Container(
              width: 60.0,
              child: TextField(
                  controller: c20,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '레저'))),
          Container(
              width: 80.0,
              child: TextField(
                  controller: c21,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '문화시설'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c22,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '사진'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c23,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '이색체험'))),
          Container(
              width: 80.0,
              child: TextField(
                  controller: c24,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '문화체험'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c25,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '역사')))
        ]),

        // 역사,,,

        Row(children: <Widget>[
          Container(
              width: 60.0,
              child: TextField(
                  controller: c30,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '바다'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c31,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '산'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c34,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '드라이브'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c35,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '산책'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c40,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '쇼핑'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c41,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '실내'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c42,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '시티'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c43,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '지역축제'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c44,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '전통한옥')))
        ]),

        //산책,,

        //전통한옥,,

        Row(children: <Widget>[
          Container(
              width: 60.0,
              child: TextField(
                  controller: c50,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '봄'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c51,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '여름'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c52,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '가을'))),
          Container(
              width: 60.0,
              child: TextField(
                  controller: c53,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: '겨울')))
        ]),
      ])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            name = cName.text.trim();
            lat = double.parse(cLat.text);
            long = double.parse(cLong.text);
            time = int.parse(cTime.text);
            popular = int.parse(cPopular.text);

            var eattribute = [
              [
                int.parse(c00.text),
                int.parse(c01.text),
                int.parse(c02.text),
                int.parse(c03.text),
                int.parse(c04.text),
                int.parse(c05.text),
                int.parse(c06.text)
              ],
              [
                int.parse(c10.text),
                int.parse(c11.text),
                int.parse(c12.text),
                int.parse(c14.text)
              ],
              [
                int.parse(c20.text),
                int.parse(c21.text),
                int.parse(c22.text),
                int.parse(c23.text),
                int.parse(c24.text),
                int.parse(c25.text)
              ],
              [
                int.parse(c30.text),
                int.parse(c31.text),
                int.parse(c34.text),
                int.parse(c35.text),
                int.parse(c40.text),
                int.parse(c41.text),
                int.parse(c42.text),
                int.parse(c43.text),
                int.parse(c44.text)
              ],
              [
                int.parse(c50.text),
                int.parse(c51.text),
                int.parse(c52.text),
                int.parse(c53.text)
              ]
            ];

            attribute = eattribute;

            // print(name);
            // print(time);
            // print(popular);
            // print(attribute);
            fb_write_place("제주도", name, lat, long, time, popular, attribute[0],
                attribute[1], attribute[2], attribute[3], attribute[4]);
            resetCtrl();
          }),
    );
  }

  void fb_write_place(city, name, latitude, longitude, takenTime, popular,
      partner, concept, play, tour, season) {
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

  void resetCtrl() {
    cName.text = "";
    cLat.text = "";
    cLong.text = "";
    cTime.text = "";
    cPopular.text = "";
    c00.text = "";
    c01.text = "";
    c02.text = "";
    c03.text = "";
    c04.text = "";
    c05.text = "";
    c06.text = "";
    c10.text = "";
    c11.text = "";
    c12.text = "";
    c14.text = "";
    c20.text = "";
    c21.text = "";
    c22.text = "";
    c23.text = "";
    c24.text = "";
    c25.text = "";
    c30.text = "";
    c31.text = "";
    c34.text = "";
    c35.text = "";
    c40.text = "";
    c41.text = "";
    c42.text = "";
    c43.text = "";
    c44.text = "";
    c50.text = "";
    c51.text = "";
    c52.text = "";
    c53.text = "";
  }
}
