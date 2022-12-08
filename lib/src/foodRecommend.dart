

import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/selectedRestaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter/services.dart';
import '../calendar_view.dart';
import '../components/image_data.dart';
import 'package:danim/map.dart';
import 'package:danim/nearby.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/model/event.dart';

import 'createMovingTimeList.dart';
import 'loadingTimeTable.dart';

class FoodRecommend extends StatefulWidget {

  List<Restaurant> restaurantList = [];
  int mealIndex = 0;
  List<CalendarEventData<Event>> events = [];
  int transit = 0;

  @override
  FoodRecommendState createState() => FoodRecommendState();

  FoodRecommend(
      this.restaurantList,
      this.mealIndex,
  this.events,
      this.transit
      );


}




class FoodRecommendState extends State<FoodRecommend> {
  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;

  Restaurant _selectedRestaurant = Restaurant('','', 0.0, 0.0);
  int lunchOrDinner = 0; //lunch : 0, dinner : 1




  static Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    }
    if (states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    } else
      return Colors.white;
  }

  void switchBackgroundColor(int index, int type) {
    if (type == 1) {
      setState(() {
        backgrouneColorList[index] = MaterialStateProperty.resolveWith(
                (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        backgrouneColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  List<MaterialStateProperty<Color>> createBackgroundColorList(List<Restaurant> restList) {

    List<MaterialStateProperty<Color>> backgroundColorList = [];

    for(int i=0; i<restList.length; i++){
      backgroundColorList.add(MaterialStateProperty.resolveWith(getColor));
    }




    return backgroundColorList;

  }



  late List<MaterialStateProperty<Color>> backgrouneColorList = createBackgroundColorList(widget.restaurantList);



  @override
  Widget build(BuildContext context) {

    //WillPopScope는 사용자가 빽키를 눌렀을때 작동되는 위젯
    return WillPopScope(
        onWillPop: () {
          setState(() {
            addMarker(pathTemp);
            addPoly(pathTemp);
          });
          return Future(() => true);
        },
    child: Scaffold(
        appBar:  AppBar(
          elevation: 0,
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
          ),
        ),
        body: Column(
            children:[
              SizedBox(
                height: 400,
                child: NaverMap(
              onMapCreated: (mcontroller) {
                setState(() {
                  mapController = mcontroller;
                });
              },
              initialCameraPosition: CameraPosition(
                  bearing: 0.0,
                  target: LatLng(33.371964, 126.543512),
                  tilt: 0.0,
                  zoom: 8.0),
              mapType: _mapType,
              markers: markers,
              pathOverlays: pathOverlays,
            )),

              SizedBox(
                height: 5
              ),
              SizedBox(
                height: 300,
                child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    child:Column(

                  children: [

                    for(int i=0; i< widget.restaurantList.length; i++)
                      Container(
                        alignment: Alignment.topLeft,
                        height: 40,
                        width: 400,
                        child: ElevatedButton(


                            style: ButtonStyle(

                                backgroundColor:
                                backgrouneColorList[i],
                            minimumSize: MaterialStateProperty.all(Size(400,40))),


                          onPressed: () {

                           // print("눌림");

                            setState(() {
                              addRestMarker( widget.restaurantList[i]);
                              switchBackgroundColor(i, 1);

                              for(int j=0;j<widget.restaurantList.length; j++) {
                              switchBackgroundColor(j, 0);

                              }

                              switchBackgroundColor(i, 1);

                              _selectedRestaurant = widget.restaurantList[i];

                            });

                          },
                            child: Text('${widget.restaurantList[i].restCategory} / ${widget.restaurantList[i].restName}',
                                style: TextStyle(
                                  fontFamily: "Neo",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 13,
                                ))   ,

                        )

                      ),

                    Container(
                      child:ElevatedButton(
                        onPressed: () async {

                          //여기서 선택한 거 반영해서 다시 타임테이블 띄우기


                          //식사 이벤트 만들기

                          //점심이면
                          if(widget.events[widget.mealIndex].startTime.hour < 16){
                            lunchOrDinner = 0;

                          }
                          else{
                            lunchOrDinner = 1;
                          }

                          CalendarEventData<Event> newMealEvent;

                          if(lunchOrDinner == 0){

                            newMealEvent = CalendarEventData<Event>(title: '점심 - ${_selectedRestaurant.restName}',event: Event(title: '점심 - ${_selectedRestaurant.restName}'), latitude: _selectedRestaurant.restLat, longitude: _selectedRestaurant.restLong, startTime: widget.events[widget.mealIndex].startTime, endTime: widget.events[widget.mealIndex].endTime, date: widget.events[widget.mealIndex].date);


                          }

                          else{
                            newMealEvent = CalendarEventData<Event>(title: '저녁 - ${_selectedRestaurant.restName}',event: Event(title: '저녁 - ${_selectedRestaurant.restName}'), latitude: _selectedRestaurant.restLat, longitude: _selectedRestaurant.restLong, startTime: widget.events[widget.mealIndex].startTime, endTime: widget.events[widget.mealIndex].endTime, date: widget.events[widget.mealIndex].date);

                          }

                          //이벤트리스트에서 식사시간 삭제, 새로운 이벤트 넣음

                          List<CalendarEventData<Event>> eventsUpdated = widget.events;
                          eventsUpdated.removeAt(widget.mealIndex);
                          eventsUpdated.insert(widget.mealIndex, newMealEvent);

                          //업데이트된 이벤트리스트에서 새롭게 프리셋 만들고 타임테이블 출력 !!


                          for (int i = 0; i < eventsUpdated.length; i++) {
                            print('journey_lat : ${eventsUpdated[i].title}');
                          }

                          List<List<Place>> newPreset = [
                            for (int i = 0;
                            i <
                                eventsUpdated[eventsUpdated.length -1].date
                                    .difference(eventsUpdated[0].date)
                                    .inDays +
                                    1;
                            i++)
                              []
                          ]; // 프리셋 초기화

                          List<DateTime> dateList = [];


                      for (int i = 0;
                      i < eventsUpdated[eventsUpdated.length -1].date
                          .difference(eventsUpdated[0].date)
                          .inDays +
                          1;
                      i++) {
                      dateList.add(DateTime(eventsUpdated[0].date.year,
                          eventsUpdated[0].date.month, eventsUpdated[0].date.day + i));
                      } // 날짜 리스트



                          for (int i = 0; i < dateList.length; i++) {
                            for (int j = 0; j < eventsUpdated.length; j++) {
                              if ((dateList[i].year == eventsUpdated[j].date.year &&
                                  dateList[i].month ==
                                      eventsUpdated[j].date.month &&
                                  dateList[i].day ==
                                      eventsUpdated[j].date.day) &&
                                  (eventsUpdated[j].title != '이동') &&
                                  (eventsUpdated[j].title != '식사시간')) {
                                newPreset[i].add(Place(
                                    eventsUpdated[j].title,
                                    eventsUpdated[j].latitude,
                                    eventsUpdated[j].longitude,
                                    eventsUpdated[j]
                                        .endTime
                                        .difference(eventsUpdated[j].startTime)
                                        .inMinutes,
                                    60,
                                    [0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0]));
                              }
                            }
                          }

                          //타임테이블 생성 잘 됐나 출력

                          for (int i = 0; i < newPreset.length; i++) {
                            for (int j = 0; j < newPreset[i].length; j++) {
                              print(
                                  '${i}째 날 ${j}째 코스 : ${newPreset[i][j].name}');
                            }
                          }

                          //print('lati : ${oldPreset[0][0].latitude}');
                          //print(oldPreset[0][0].longitude);





                          print(newPreset);
                         // print(movingTimeList);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingTimeTable(
                                    newPreset,
                                    widget.transit,

                                    eventsUpdated[0].startTime.hour,
                                   eventsUpdated[eventsUpdated.length-1].endTime.hour,

                                  )));





                          setState(() {
                            //selectedRestaurant = _selectedRestaurant;
                          });



                        },
                        child:  Text('식당 선택하기',
                            style: TextStyle(
                              fontFamily: "Neo",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 13,
                            ))
                      )
                    )

                    ]





                )
              )




              )


            ]) ));
  }
}

