import 'package:flutter/material.dart';
import 'package:danim/tourinfo.dart';

String photoURL='https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=';
class ViewPhoto extends StatefulWidget {
  const ViewPhoto({super.key});

  @override
  ViewPhotoState createState() => ViewPhotoState();
}
class ViewPhotoState extends State<ViewPhoto> {

  String photourl='https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사진')),
      body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: <Widget>[

      for(int i=0;i<photoList.length;i++)
        Container(child: Image.network('${photoURL}${photoList[i]}&key=AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI')),

      ],
    ),
    ));
  }
}