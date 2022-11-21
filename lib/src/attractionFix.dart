

import 'package:danim/src/date_selectlist.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../components/image_data.dart';
import '../map.dart';
import '../route_ai.dart';
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

  get mapController => null;


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
                    child: InkWell(
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                            mode: Mode.overlay,
                            language: "kr",
                            //types: [],
                            //strictbounds: false,
                            components: [Component(Component.country, 'kr')],
                            //google_map_webservice package
                            //onError: (err){
                            //  print(err);
                            //},
                          );

                          if(place != null){
                            setState(() {
                              location = place.description.toString();
                            });

                            //form google_maps_webservice package
                            final plist = GoogleMapsPlaces(apiKey:'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                              //from google_api_headers package
                            );

                            String placeid = place.placeId ?? "0";

                            final detail = await plist.getDetailsByPlaceId(placeid);
                            final geometry = detail.result.geometry!;
                            final lat = geometry.location.lat;
                            final lang = geometry.location.lng;
                            var newlatlang = LatLng(lat, lang);
                            latLen.add(newlatlang);

                            //move map camera to selected place with animation
                            //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                            var places=location.split(', ');
                            String placeName=places[places.length-1];
                            print('$placeName placeName');
                            placeList.add(Place(placeName, lat, lang, 60, 20, selectedList[0], selectedList[1], selectedList[2], selectedList[3], selectedList[4]));
                            setState(() {
                            });
                            setState(() {
                            });
                          }
                        },
                        child:Padding(
                          padding: EdgeInsets.all(15),
                          child: Card(
                            child: Container(
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width - 40,
                                child: ListTile(
                                  title:Text(location, style: TextStyle(fontSize: 18),),
                                  trailing: Icon(Icons.search),
                                  dense: true,
                                )
                            ),
                          ),
                        )
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