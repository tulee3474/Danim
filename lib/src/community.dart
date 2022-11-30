import 'package:danim/calendar_view.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/writtenPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
//import 'package:danim/src/exampleResource.dart';
import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import '../model/event.dart';

import 'myJourney.dart';
import 'newPost.dart';

var readData; //List<Post>가 들어올 변수




Future readPostData() async {
  var read = ReadController();

  readData = await read.fb_read_all_post(); // List<Post>
}

class Post {
  String postTitle = ""; // 게시물 제목
  int postNum = 0; // 게시물 넘버
  String postWriter = ""; // 작성자 이름
  List<String> commentList = []; // 댓글 리스트
  List<String> commentWriterList = []; // 댓글 작성자 리스트
  List<String> recommendList = []; // 좋아요 누른 사람 리스트
  int recommendNum = 0;
  String postContent = '';

  Post(this.postTitle, this.postNum, this.postWriter, this.commentList,this.commentWriterList, this.recommendList, this.recommendNum, this.postContent); // 좋아요 수
}

List<Post> posts = [];

/*
  //Post 객체 구성 - readData[0], readData[1] 이런식으로 쓰면 돼!
  String postTitle = ""; // 게시물 제목
  int postNum = 0; // 게시물 넘버
  String postWriter = ""; // 작성자 이름
  List<String> commentList = []; // 댓글 리스트
  List<String> commentWriterList = []; // 댓글 작성자 리스트
  List<String> recommendList = []; // 좋아요 누른 사람 리스트
  int recommendNum = 0; // 좋아요 수

  postNum는 length써서 추가할 것 -? 이게 무슨 말?

  //사용 가능한 함수

  fb_add_post(postTitle, postNum, postWriter) // 게시글 추가 - 게시글 제목, 게시글 넘버, 작성자

  fb_add_comment(postTitle, comment, commentWriter) // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자

  fb_add_recommend(postTitle, recommender, recommendNum)  // 좋아요 추가 - 게시글 제목, 누른사람, 기존 좋아요 개수

  삭제는 구현 안함 그냥!
*/

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Image.asset(IconsPath.house,
                    fit: BoxFit.contain, height: 20))
          ]),
        ),
        body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:Column(
          children:[
            Container(
              padding: EdgeInsets.fromLTRB(0,20,0,0),
              child: Text("글 목록")
            ),

            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),

            for(int i=0; i<posts.length; i++)
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Text('${posts[i].postNum + 1}. ${posts[i].postTitle}'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WrittenPost(posts[i])));
                  },
                )
              )




          ]
        )),

    floatingActionButton: FloatingActionButton(
      child:Icon(Icons.add),
      elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewPost()));
        },
    ),);
  }
}
