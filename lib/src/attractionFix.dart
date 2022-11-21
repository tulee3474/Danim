

import 'package:danim/src/start_end_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/image_data.dart';
import 'loading.dart';

class AttractionFix extends StatefulWidget{
  @override
  State<AttractionFix> createState() => _AttractionFixState();

  int transit = 0;

  AttractionFix(
      this.transit
      );

}

class _AttractionFixState extends State<AttractionFix> {
  int attractionNum = 3;

  List<TextEditingController> tourSpotName = []; //여기에 관광지 이름 저장
  List<int> onWhatDate = []; //여기에 어떤 날에 갈 지 저장

  int dayNum = endDay.difference(startDay).inDays;


  @override
  void init() {
    super.initState();
  }

  @override
  void dispose() {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset(IconsPath.back,
                    fit: BoxFit.contain, height: 20))
          ]),
        ),
        body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
        child:Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text('꼭 방문하길 원하는 관광지가 있으신가요?',

                      style: TextStyle(

                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ))),


              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Divider(color: Colors.grey, thickness: 2.0)),

              for(int i = 0; i < attractionNum; i++)

                Row(
                    children: [Container(
                      width: 200,
                    padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
                    child: TextField(

                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '관광지 검색'
                      ),

                    )
                ),

                      Container(
                        width: 50,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            labelText: '며칠차에?'
                          ),
                        )
                      )
                    ]),

              Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => Loading(widget.transit)));
                      },
                      child: Text("다음 단계")
                  )
              )


            ]
        )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            attractionNum++;
          });
        },
        child: Icon(Icons.add)
      )
    );
  }
}