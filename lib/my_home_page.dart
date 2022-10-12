// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
////파란 줄을 없애기 위한 빠른 수정

import 'package:flutter/material.dart';

//import 'main.dart';
import 'firebase_read_write.dart';
import 'route_ai.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _TmpPageState createState() => _TmpPageState();
}

class _TmpPageState extends State<MyHomePage> {
  final point_city_ctrl = TextEditingController();
  final point_name_ctrl = TextEditingController();
  final point_latitude_ctrl = TextEditingController();
  final point_longitude_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //도화지
      appBar: AppBar(
        //상단바
        title: Text(
            "Danim (다님)"), //Myapp class의 매개인자 가져옴 : Testing Thomas Home Page
        centerTitle: true, //중앙정렬
        backgroundColor: Colors.redAccent,
        elevation: 5.0, //붕떠 있는 느낌(바 하단 그림자)

        // leading: IconButton(  //leading은 아이콘 버튼이나 간단한 위젯을 왼쪽에 배치
        //   icon: Icon(Icons.menu),
        //   onPressed: () { //터치, 클릭하면 번쩍하는 이벤트
        //     print('menu button is clicked.');
        //   }

        // ),

        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.

          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                print('shopping button is clicked.');
              }),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('search button is clicked.');
              }),
        ],
      ),

      drawer: Drawer(
        //왼쪽 메뉴를 만들어보나
        child: ListView(
          //클릭했을때 리스트 보여주기
          padding: EdgeInsets.zero, //빈공간 0
          children: [
            UserAccountsDrawerHeader(
              //사용자 헤드 메세지 부분
              accountName: Text('Thomas'), //필수 입력 사항
              accountEmail: Text('tulee3474@naver.com'), //필수 입력 사항
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/picture.jpg'),
              ),
              onDetailsPressed: () {
                //리스트 뷰 화면에서 화살표 모양의 오른쪽 버튼
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                  //사용자 계정 이미지(위쪽 하늘색 부분)
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.only(
                    //사각형 이미지의 아래쪽 둥글게
                    bottomLeft: Radius.circular(40.0), //40.0은 둥글게 만들어주는 상수 값
                    bottomRight: Radius.circular(40.0),
                  )),
            ),
            ListTile(
              //왼쪽 끝에 아이콘 배치한 리스트
              leading: Icon(Icons.home, color: Colors.grey),
              title: Text('Home'),
              onTap: () {
                //두번 터치 or 쭉 눌렀을때 이벤트 발생
                print('Home is clicked.');
              },
              trailing: Icon(Icons.add), //trailing - 오른쪽 끝에 배치하는것
            ),
            ListTile(
              //왼쪽 끝에 아이콘 배치한 리스트
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Setting'),
              onTap: () {
                //두번 터치 or 쭉 눌렀을때 이벤트 발생
                print('Setting is clicked.');
              },
              trailing: Icon(Icons.add), //trailing - 오른쪽 끝에 배치하는것
            ),
            ListTile(
              //왼쪽 끝에 아이콘 배치한 리스트
              leading: Icon(Icons.question_answer, color: Colors.grey),
              title: Text('Q&A'),
              onTap: () {
                //두번 터치 or 쭉 눌렀을때 이벤트 발생
                print('Q&A is clicked.');
              },
              trailing: Icon(Icons.add), //trailing - 오른쪽 끝에 배치하는것
            ),
            ElevatedButton(
              child: Text('스낵바 버튼'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Flutter3.0 Snack method test'))); //onPressed에 세미콜론!!!!
              },
            )
          ],
        ),
      ),

      backgroundColor: Color.fromARGB(255, 210, 255, 105),
      body: Padding(
        //Padding은 위치 조절 가능, Center는 중앙, 옆에 전구 눌러서 수정해도된다
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
        //LTAB에서부터위치 (left,top,right,bottom)

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //가로축 정렬을 위한 위젯
          children: [
            Text(
              'Name',
              style: TextStyle(
                color: Color.fromARGB(255, 71, 17, 158),
                letterSpacing: 2.0, //글씨의 간격
              ),
            ),
            SizedBox(
              //텍스트 사이에 안보이는 박스를 넣어서 간격 조정
              height: 10.0,
            ),
            Text(
              'Thomas',
              style: TextStyle(
                  color: Color.fromARGB(255, 71, 17, 158),
                  letterSpacing: 3.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/Logo.png'),
                radius: 80.0,
                backgroundColor: Colors.black,
              ),
            ),
            Row(
              children: [
                Icon(Icons.check_circle_outline),
                //위젯 중 하나, Ctrl + Space로 체크 가능
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Capstone Design',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                  ),
                ),
              ],
            ),
            Divider(
              //구분선
              height: 60.0, //위아래 30씩 거리조절
              color: Colors.grey,
              thickness: 0.5, //두께
              endIndent: 30.0, //끝에서 부터 어느정도 떨어질 것인지 설정
            ),
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
            Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                    controller: point_latitude_ctrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Point Latitude',
                    ))),
            Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                    controller: point_longitude_ctrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Point Longitude',
                    ))),
            Row(
              // 버튼 두개 만들기
              children: [
                ElevatedButton(
                    onPressed: () {
                      print('ElevatedButton - onPressed');
                      fb_write_point(
                          point_city_ctrl.text,
                          point_name_ctrl.text,
                          double.parse(point_latitude_ctrl.text),
                          double.parse(point_longitude_ctrl.text));
                      resetCtrl();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Firebase에 데이터 전송 완료')));
                    },
                    onLongPress: () {
                      print('ElevatedButton - onLongPress');
                      fb_write_point(
                          point_city_ctrl.text,
                          point_name_ctrl.text,
                          double.parse(point_latitude_ctrl.text),
                          double.parse(point_longitude_ctrl.text));
                      resetCtrl();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Firebase에 데이터 전송 완료')));
                    },
                    // button 스타일은 여기서 작성한다.
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('업로드')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteAI()),
                    );
                    print('ElevatedButton - onPressed');
                  },
                  onLongPress: () {
                    print('ElevatedButton - onLongPress');
                  },
                  // button 스타일은 여기서 작성한다.
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 47, 0, 255),
                  ),
                  child: const Text('데이터 확인'),
                ),
              ],
            ),
          ], //웬만한건 이거 안쪽에!
        ),
      ),
    );
  }

  void resetCtrl() {
    point_name_ctrl.text = "";
    point_latitude_ctrl.text = "";
    point_longitude_ctrl.text = "";
  }
}
