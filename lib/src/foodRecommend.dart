import 'package:danim/src/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/image_data.dart';

class FoodRecommend extends StatelessWidget {
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
        body: Container(
            padding: EdgeInsets.fromLTRB(175, 50, 0, 0), child: Text("주변 맛집")));
  }
}
