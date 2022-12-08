import 'package:danim/firebase_read_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/src/community.dart';
import 'package:danim/src/post.dart';

import '../components/image_data.dart';
import 'login.dart';

class WrittenPost extends StatefulWidget {
  void aaaa() {
    for (int i = 0; i < post.commentWriterList.length; i++) {
      if (!countedCommentWriterList.contains(post.commentWriterList[i])) {
        countedCommentWriterList.add(post.commentWriterList[i]);
      }
    }
  }

  Post post = Post('', 0, '', [], [], [], 0, '');
  int index = 0;
  List<String> countedCommentWriterList = [];

  WrittenPost(this.post, this.index);

  @override
  _WrittenPostState createState() => _WrittenPostState();
}

class _WrittenPostState extends State<WrittenPost> {
  //TextEditingController commentWriterController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  initState() {
    widget.aaaa();
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 102, 202, 252),
          child: Icon(Icons.thumb_up),
          onPressed: () {
            if (widget.post.recommendList.contains(token)) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: SizedBox(
                      width: 250,
                      height: 100,
                      child: Center(
                          child: Text("이미 좋아요를 누르셨습니다.",
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontFamily: 'Neo',
                                //fontWeight: FontWeight.bold,
                              ))),
                    ));
                  });
            } else {
              setState(() {
                fb_add_recommend(
                    widget.post.postTitle,
                    token!,
                    widget
                        .post.recommendNum); // 좋아요 추가 - 게시글 제목, 누른사람, 기존 좋아요 개수
                widget.post.recommendNum++;
                widget.post.recommendList.add(token!);
              });
            }
          },
        ),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        /*
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text("${widget.post.postTitle}",
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Neo',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                               )))*/


                        /*
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            strutStyle: StrutStyle(fontSize: 14.0),
                            text: TextSpan(
                                text: (widget.post.postTitle),
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  //height: 1.4,
                                  fontFamily: 'Neo',
                                  fontSize: 20.0,
                                )),
                          ),
                        ),


                         */

                        Flexible(
                          child: SelectableText.rich(
                            TextSpan(text: (widget.post.postTitle),
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  //height: 1.4,
                                  fontFamily: 'Neo',
                                  fontSize: 20.0,
                                )

                            )
                          ),
                        ),



                        Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            child: Text("익명의 글쓴이${widget.index + 1}",
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Neo',
                                  fontSize: 10.0,
                                  //fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                    child: SelectableText.rich(
                    TextSpan(text: (widget.post.postContent),
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        //height: 1.4,
                        fontFamily: 'Neo',
                        fontSize: 14.0,
                      )

                  )
        ),
    ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text("좋아요 : ${widget.post.recommendNum}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Neo',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text("댓글",
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Neo',
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
                  for (int i = 0; i < widget.post.commentList.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                  "익명 ${widget.countedCommentWriterList.indexOf(widget.post.commentWriterList[i]) + 1} : ${widget.post.commentList[i]}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontFamily: 'Neo',
                                    fontSize: 11.0,
                                    //fontWeight: FontWeight.bold,
                                  ))),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        width: 115,
                        height: 55,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ElevatedButton(
                            child: Text('댓글 작성',
                                style: TextStyle(
                                  letterSpacing: 2.0,
                                  fontFamily: 'Neo',
                                  //fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            style: ButtonStyle(),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: SizedBox(
                                            width: 300,
                                            height: 300,
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(children: [
                                                  TextField(
                                                    controller:
                                                        commentController,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: '댓글 내용'),
                                                  ),
                                                  Container(
                                                      width: 110,
                                                      height: 60,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 20, 0, 0),
                                                      child: ElevatedButton(
                                                        child: Text('댓글 작성',
                                                            style: TextStyle(
                                                              letterSpacing:
                                                                  2.0,
                                                              fontFamily: 'Neo',
                                                              //fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        style: ButtonStyle(),
                                                        onPressed: () {
                                                          setState(() {
                                                            widget.post
                                                                .commentWriterList
                                                                .add(token!);
                                                            widget.post
                                                                .commentList
                                                                .add(
                                                                    commentController
                                                                        .text);

                                                            fb_add_comment(
                                                                widget.post
                                                                    .postTitle,
                                                                widget.post
                                                                    .commentList[widget
                                                                        .post
                                                                        .commentList
                                                                        .length -
                                                                    1],
                                                                widget.post
                                                                    .commentWriterList); // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자 리스트

                                                            commentController
                                                                .text = '';
                                                          });

                                                          //잘 들어갔나 확인
                                                          print(widget.post
                                                              .commentList[widget
                                                                  .post
                                                                  .commentList
                                                                  .length -
                                                              1]);
                                                          print(widget.post
                                                              .commentWriterList[widget
                                                                  .post
                                                                  .commentWriterList
                                                                  .length -
                                                              1]);

                                                          //여기서 DB에 저장

                                                          //팝업 창 꺼짐
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ))
                                                ]))));
                                  });
                            })),
                  ),
                ],
              )),
        ));
  }
}
