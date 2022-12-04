import 'package:danim/firebase_read_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/src/post.dart';

import '../components/image_data.dart';
import 'community.dart';
import 'login.dart';

class NewPost extends StatefulWidget {
  NewPost();

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  Post newPost = Post('', posts.length, '', [], [], [], 0, '');

  TextEditingController postTitleController = TextEditingController();
  //TextEditingController postWriterController = TextEditingController();
  TextEditingController postContentController = TextEditingController();

  @override
  initState() {
    super.initState();
    postTitleController = TextEditingController();
    postContentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("새로운 글 작성",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontFamily: 'Neo',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F4),
                    border: Border(
                      top: BorderSide(width: 1.0, color: Color(0xffD4D4D4)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: postTitleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '제목'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: postContentController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: '내용'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      width: 110,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('글 저장',
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontFamily: 'Neo',
                              //fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ButtonStyle(),
                        onPressed: () {
                          setState(() {
                            posts.add(Post(
                                postTitleController.text,
                                posts.length,
                                token!,
                                [],
                                [],
                                [],
                                0,
                                postContentController.text));
                            fb_add_post(
                                postTitleController.text,
                                posts.length - 1,
                                token!,
                                postContentController
                                    .text); // 게시글 추가 - 게시글 제목, 게시글 넘버, 작성자, 게시글 내용
                          });

                          //잘 들어갔나 확인

                          print(posts[posts.length - 1].postTitle);
                          print(posts[posts.length - 1].postWriter);
                          print(posts[posts.length - 1].postContent);

                          //여기서 DB에 저장

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Community()));
                        },
                      )),
                )
              ])),
        ));
  }
}
