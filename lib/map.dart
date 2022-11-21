import 'package:flutter/material.dart';
import 'nearby.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'package:danim/src/place.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'route_ai.dart';

// list of locations to display polylines
List<LatLng> latLen = [
  //const LatLng(37.507941, 127.009686),
  //const LatLng(37.302263, 126.977977)
];
List<LatLng> latLen2 = [
  //const LatLng(37.507941, 127.009686),
  //const LatLng(37.302263, 126.977977)
];
List<LatLng> latLen3 = [
  //const LatLng(37.507941, 127.009686),
  //const LatLng(37.302263, 126.977977)
];

final List<Marker> markers = [];
final Set<PathOverlay> pathOverlays = {};

/*void addMarker(String placeName, double lat, double lng) {
  markers.add(Marker(
    markerId: placeName,
    position: LatLng(lat, lng),
    infoWindow: placeName,
  ));
}*/
void addMarker(List<List<Place>> pathList) {
  markers.clear();
  for (int i = 0; i < pathList.length; i++) {
    for (int j = 0; j < pathList[i].length; j++) {
      markers.add(Marker(
        markerId: pathList[i][j].name,
        position: LatLng(pathList[i][j].latitude, pathList[i][j].longitude),
        infoWindow: pathList[i][j].name,
        width: 20,
        height: 20,
      ));
    }
  }
}

void addPoly(List<List<Place>> pathList) {
  latLen.clear();
  latLen2.clear();
  latLen3.clear();
  for (int i = 0; i < pathList[0].length; i++) {
    latLen.add(LatLng(pathList[0][i].latitude, pathList[0][i].longitude));
  }
  for (int i = 0; i < pathList[1].length; i++) {
    latLen2.add(LatLng(pathList[1][i].latitude, pathList[1][i].longitude));
  }
  for (int i = 0; i < pathList[2].length; i++) {
    latLen3.add(LatLng(pathList[2][i].latitude, pathList[2][i].longitude));
  }
  pathOverlays.add(PathOverlay(PathOverlayId('path1'), latLen,
      color: Colors.green, width: 7, outlineWidth: 0));
  pathOverlays.add(PathOverlay(PathOverlayId('path2'), latLen2,
      color: Colors.pink, width: 7, outlineWidth: 0));
  pathOverlays.add(PathOverlay(PathOverlayId('path3'), latLen3,
      color: Colors.deepOrange, width: 7, outlineWidth: 0));
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  //_MapState createState() => _MapState();
  NaverMapState createState() => NaverMapState();
}

String location = "Search Location";

class NaverMapState extends State<Map> {
  //Completer<NaverMapController> _controller = Completer();
  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;

  @override
  Widget build(BuildContext context) {
    bool houseCheck = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NaverMap Test'),
        actions: [
          //action은 복수의 아이콘, 버튼들을 오른쪽에 배치, AppBar에서만 적용
          //이곳에 한개 이상의 위젯들을 가진다.
          IconButton(
              icon: Icon(Icons.house),
              onPressed: () {
                if (houseCheck) {
                  houseCheck = false;
                } else {
                  houseCheck = true;
                }
                print('search button is clicked.');
              }),
          ElevatedButton(
            onPressed: () async {
              print('ElevatedButton - onPressed');
              //Navigator.pop(context);
              //여기서 AI 실행하고 결과를 지도에 표시
              var ai = RouteAI(); //RouteAI 클래스 생성

              List<List<List<Place>>> read_data;

              //임시 selectList
              List selectList = [
                [0, 1, 0, 0, 0, 0, 0],
                [0, 1, 0, 1],
                [0, 1, 0, 0, 1, 0],
                [0, 1, 0, 1, 0, 1, 1, 0, 1],
                [0, 1, 0, 0]
              ];
              var stopwatch = Stopwatch();
              stopwatch.start();

              await ai.data_loading("제주도");

              //임시 숙소
              Place? house = Place(
                  "제주신라호텔",
                  33.2475582,
                  126.4081161,
                  0,
                  0,
                  [0, 1, 0, 0, 0, 0, 0],
                  [0, 1, 0, 1],
                  [0, 1, 0, 0, 1, 0],
                  [0, 1, 0, 1, 0, 1, 1, 0, 1],
                  [0, 1, 0, 0]);
              if (!houseCheck) {
                house = null;
              }

              //read_data = await ai.route_search("제주도", selectList, 600, 3);
              read_data = (await ai.route_search("제주도", house,
                      ["성산일출봉"], [1], selectList, [9, 18], 3, 3))
                  .cast<List<List<Place>>>();
              //print("route_search함수 실행 후 리턴");
              //print(read_data);

              for (int i = 0; i < read_data.length; i++) {
                print("코스");
                for (int j = 0; j < read_data[i].length; j++) {
                  print("날짜 : " + (j + 1).toString());
                  for (int k = 0; k < read_data[i][j].length; k++) {
                    print(read_data[i][j][k].name);
                  }
                }
                print("---------------------------");
              }
              print("AI 돌리는데 걸리는 시간");
              print(stopwatch.elapsed);
              stopwatch.stop();

              int houseCount = 0;
              int polycount = 0;
              int iSave = 0;

              // setState(() {
              //   //임시로 0번째 코스만 해보자
              //   for (int i = 0; i < read_data[0].length; i++) {
              //     if (read_data[0][i].name != '더미') {
              //       addMarker(read_data[0][i].name, read_data[0][i].latitude,
              //           read_data[0][i].longitude);
              //     }

              //     if (read_data[0][i].name == house?.name ||
              //         read_data[0][i].name == '더미') {
              //       houseCount += 1;
              //     }
              //     if (houseCount == 2) {
              //       for (int j = iSave; j < i; j++) {
              //         latLen.add(LatLng(
              //             read_data[0][j].latitude, read_data[0][j].longitude));
              //       }
              //       latLen.add(LatLng(read_data[0][iSave].latitude,
              //           read_data[0][iSave].longitude));

              //       //houseCount = 0;
              //       //latLen = [];
              //       iSave = i;
              //       if (!houseCheck) {
              //         print(latLen.length);
              //         latLen.removeWhere((element) =>
              //             element.latitude == 0.0 || element.longitude == 0.0);
              //         print(latLen.length);
              //       }
              //     }
              //     if (houseCount == 4) {
              //       for (int j = iSave; j < i; j++) {
              //         latLen2.add(LatLng(
              //             read_data[0][j].latitude, read_data[0][j].longitude));
              //       }

              //       latLen2.add(LatLng(read_data[0][iSave].latitude,
              //           read_data[0][iSave].longitude));
              //       iSave = i;
              //       if (!houseCheck) {
              //         print(latLen.length);
              //         latLen2.removeWhere((element) =>
              //             element.latitude == 0.0 || element.longitude == 0.0);
              //         print(latLen.length);
              //       }
              //     }

              //     if (houseCount == 6) {
              //       for (int j = iSave; j < i; j++) {
              //         latLen3.add(LatLng(
              //             read_data[0][j].latitude, read_data[0][j].longitude));
              //       }

              //       latLen3.add(LatLng(read_data[0][iSave].latitude,
              //           read_data[0][iSave].longitude));
              //       iSave = i;
              //       if (!houseCheck) {
              //         print(latLen.length);
              //         latLen3.removeWhere((element) =>
              //             element.latitude == 0.0 || element.longitude == 0.0);
              //         print(latLen.length);
              //       }
              //     }
              //   }
              //   addPoly([
              //     Colors.pink,
              //     Colors.green,
              //     Colors.purple,
              //     Colors.brown,
              //     Colors.black
              //   ]);
              // });
            },
            onLongPress: () {
              print('ElevatedButton - onLongPress');
            },
            // button 스타일은 여기서 작성한다.
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange,
            ),
            child: const Text('Ai실행'),
          ),
        ],
      ),
      body: Stack(children: [
        NaverMap(
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          initialCameraPosition: CameraPosition(
              bearing: 0.0,
              target: LatLng(33.371964, 126.543512),
              tilt: 0.0,
              zoom: 9.0),
          mapType: _mapType,
          markers: markers,
          pathOverlays: pathOverlays,
        ),
        Positioned(
          //search input bar
          top: 10,
          child: InkWell(
            onTap: () async {
              var place = await PlacesAutocomplete.show(
                context: context,
                apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                mode: Mode.overlay,
                language: "kr",
                components: [Component(Component.country, 'kr')],
                //google_map_webservice package
              );

              if (place != null) {
                setState(() {
                  location = place.description.toString();
                });

                //form google_maps_webservice package
                final plist = GoogleMapsPlaces(
                  apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
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
                setState(() {
                  CameraPosition cameraPosition = CameraPosition(
                      bearing: 0.0, target: newlatlang, tilt: 0.0, zoom: 14.0);
                  //move map camera to selected place with animation
                  CameraUpdate cameraUpdate =
                      CameraUpdate.toCameraPosition(cameraPosition);
                  mapController?.moveCamera(cameraUpdate);
                });

                var places = location.split(', ');
                //String placeName=await getDrivingDuration(33.5170488, 126.5033901, 33.5042977, 126.954048);
                String placeName = places[places.length - 1];
                //placeList.add(Place(placeName, lat, lang));

                setState(() {
                  //addRestMarker();
                  //addCafeMarker();
                  //addAccommodationMarker();
                  getRestaurant(lat, lang);
                  getCafe(lat, lang);
                  getAccommodation(lat, lang);
                  //addMarker(placeName, lat, lang);
                  //addPoly(Colors.pink);
                });
                setState(() {});
              }
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    )),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
/*
class _MapState extends State<Map> {

  // created controller to display Google Maps
  Completer<GoogleMapController> _controller = Completer();
  //on below line we have set the camera position
  static final CameraPosition _kGoogle = CameraPosition(
    target: LatLng(33.4426234, 126.537055),
    zoom: 10,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  void addRestMarker() {
    for(int i=0;i<restaurantList.length;i++) {
      _markers.add(
        // added markers
          Marker(
            markerId: MarkerId((i+1000).toString()),
            position: LatLng(restaurantList[i].restLat,restaurantList[i].restLong), //
            infoWindow: InfoWindow(
                title: restaurantList[i].restName,
                snippet: restaurantList[i].restCategory//await getTransitSteps(placeList[i-1].name, placeList[i].name)
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          )
      );
    }
  }

  void addCafeMarker() {
    for(int i=0;i<cafeList.length;i++) {
      _markers.add(
        // added markers
          Marker(
            markerId: MarkerId((i+2000).toString()),
            position: LatLng(cafeList[i].cafeLat,cafeList[i].cafeLong), //
            infoWindow: InfoWindow(
                title: cafeList[i].cafeName,
                snippet: cafeList[i].cafeCategory//await getTransitSteps(placeList[i-1].name, placeList[i].name)
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          )
      );
    }
  }

  void addAccommodationMarker() {
    for(int i=0;i<cafeList.length;i++) {
      _markers.add(
        // added markers
          Marker(
            markerId: MarkerId((i+3000).toString()),
            position: LatLng(accommodationList[i].accoLat,accommodationList[i].accoLong), //
            infoWindow: InfoWindow(
                title: accommodationList[i].accoName,
                snippet: accommodationList[i].accoCategory//await getTransitSteps(placeList[i-1].name, placeList[i].name)
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          )
      );
    }
  }

  void addMarker() async{

    //convert(duration[duration.length-1]);
    int i=placeList.length-1;

    if (i>0)
      {
        String durat= await getTransitDuration(placeList[i-1].getName(), placeList[i].getName());
        String st=await getTransitSteps(placeList[i-1].getName(), placeList[i].getName());
        _markers.add(
          // added markers
          Marker(
            markerId: MarkerId(i.toString()),
            position: latLen[i], //
            infoWindow: InfoWindow(
                title: placeList[i].name,
                snippet: durat//await getTransitSteps(placeList[i-1].name, placeList[i].name)
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
    );
      }else {
    _markers.add(
      // added markers
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i], //LatLng(placeList[i].latitude,placeList[i].longitude)
          infoWindow: InfoWindow(
            title: placeList[i].name,
            snippet: i.toString()//placeList[i].name
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
    );}
  }

  void addPoly(){
    _polyline.add(
        Polyline(
          polylineId: const PolylineId('1'),
          width: 5,
          points: latLen,
          color: Colors.green,
        )
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // declared for loop for various locations
/*
    for(int i=0; i<latLen.length; i++){
      addMarker(i);
      /*_markers.add(
        // added markers
          Marker(
            markerId: MarkerId(i.toString()),
            position: latLen[i], //
            infoWindow: InfoWindow(
              title: "관광지 ${i+1}",
              snippet: "관광지 ${i+1}",
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );*/

      /*_polyline.add(
          Polyline(
            polylineId: const PolylineId('1'),
            width: 5,
            points: latLen,
            color: Colors.green,
          )
      );*/
    }
    addPoly();
    setState(() {

    });*/
  }
  String location = "Search Location";
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F9D58),
        // title of app
        title: Text("Danim"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            //given camera position
            initialCameraPosition: _kGoogle,
            // on below line we have given map type
            mapType: MapType.normal,
            // specified set of markers below
            markers: _markers,
            // on below line we have enabled location
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // on below line we have enabled compass location
            compassEnabled: true,
            // on below line we have added polylines
            polylines: _polyline,
            // displayed google map
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),


 */

    /*Positioned(
      bottom:30,
      child: ElevatedButton(
        child:Text(
          '마커 제거',
        ),
        onPressed: (){
          setState(() {
            latLen.removeLast();
            _markers.remove(MarkerId((_markers.length-1).toString()));
            _polyline.remove(PolylineId('1'));
          });
        },
      )
    ),
    Positioned(  //search input bar
      top:10,
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
        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
        var places=location.split(', ');
        String placeName=places[places.length-1];
        placeList.add(Place(placeName, lat, lang));
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
      )

      ]
      ),
      );
  }
}*/

/*
double longitudeCalculate() {
  double cameraLongitude=0.0;
  for(int i=0; i<latLen.length; i++) {
    cameraLongitude+=latLen[i].longitude;
  }
  cameraLongitude/=latLen.length;
  return cameraLongitude;
}

double latitudeCalculate() {
  double cameraLatitude=0.0;
  for(int i=0; i<latLen.length; i++) {
    cameraLatitude+=latLen[i].latitude;
  }
  cameraLatitude/=latLen.length;
  return cameraLatitude;
}*/
/*
void route() async{
  http.Response response=await http.get(Uri.parse(
      "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${latLen[0].longitude},${latLen[0].latitude}&goal=${latLen[1].longitude},${latLen[1].latitude}&option=trafast"
  ),headers: {"X-NCP-APIGW-API-KEY-ID": "piv474r6sz",
    "X-NCP-APIGW-API-KEY": "Ugcq7WpbmUSu010hzNpE4bFFXO1E3Ds983KBKwSI"}
  );
  sta=response.statusCode.toString();
  if (response.statusCode<200 || response.statusCode>400){
    //error핸들링
  } else {
    String responseData=utf8.decode(response.bodyBytes);
    var responseBody=jsonDecode(responseData);
    //duration=responseBody.toString();
    duration=(responseBody['route']['trafast'][0]['summary']['duration'].toString());
  }
}
*/