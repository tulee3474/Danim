import 'package:flutter/material.dart';
import 'package:danim/tourinfo.dart';

String photoURL =
    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=';

class ViewPhoto extends StatefulWidget {
  const ViewPhoto({super.key});

  @override
  ViewPhotoState createState() => ViewPhotoState();
}

class ViewPhotoState extends State<ViewPhoto> {
  String photourl =
      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: InkWell(
              child: Text('사진 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              if (photoList.isEmpty)
                Text('사진정보가 없습니다.')
              else
                for (int i = 0; i < photoList.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        child: Image.network(
                            '${photoURL}${photoList[i]}&key=AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI')),
                  ),
            ],
          ),
        ));
  }
}
