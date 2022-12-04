import 'package:flutter/material.dart';
import 'package:danim/tourinfo.dart';
class ViewPhoto extends StatefulWidget {
  ViewPhoto(
          {Key? key,
            required this.placeName})
              : super(key: key);
  String placeName='';

  @override
  ViewPhotoState createState() => ViewPhotoState();
}
class ViewPhotoState extends State<ViewPhoto> {
  String getPlaceName() {
    return widget.placeName;
  }
  String photourl='https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사진')),
      body: Column(
        children: <Widget>[

          Image.network('https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRvAAAAwMpdHeWlXl-lH0vp7lez4znKPIWSWvgvZFISdKx45AwJVP1Qp37YOrH7sqHMJ8C-vBDC546decipPHchJhHZL94RcTUfPa1jWzo-rSHaTlbNtjh-N68RkcToUCuY9v2HNpo5mziqkir37WU8FJEqVBIQ4k938TI3e7bf8xq-uwDZcxoUbO_ZJzPxremiQurAYzCTwRhE_V0&key=AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI'),
        ],
      ),
    );
  }
}