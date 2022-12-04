import 'package:danim/firebase_read_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/src/community.dart';
import 'package:danim/src/post.dart';

import '../components/image_data.dart';
import 'login.dart';

class WrittenPost extends StatefulWidget {
  Post post = Post('', 0, '', [], [], [], 0, '');
  int index = 0;

  WrittenPost(this.post, this.index);

  @override
  _WrittenPostState createState() => _WrittenPostState();
}

class _WrittenPostState extends State<WrittenPost> {
  //TextEditingController commentWriterController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.monitor_heart),
          onPressed: () {
            if (widget.post.recommendList.contains(token)) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: SizedBox(
                      width: 200,
                      height: 100,
                      child: Center(child: Text("이미 좋아요를 누르셨습니다.")),
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

//여기서 DB에 저장
          },
        ),
        appBar: AppBar(
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/app');
                },
                child: Image.asset(IconsPath.house,
                    fit: BoxFit.contain, height: 20))
          ]),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text("${widget.post.postTitle}")),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("익명의 글쓴이 ${widget.index + 1}")),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Divider(color: Colors.grey, thickness: 2.0)),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child:
                        TextFormField(initialValue: widget.post.postContent)),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("좋아요 개수 : ${widget.post.recommendNum}")),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Divider(color: Colors.grey, thickness: 2.0)),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("댓글")),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Divider(color: Colors.grey, thickness: 2.0)),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ElevatedButton(
                        child: Text('댓글 작성',
                            style: TextStyle(color: Colors.black)),
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
                                                controller: commentController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: '댓글 내용'),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 20, 0, 0),
                                                  child: ElevatedButton(
                                                    child: Text('댓글 작성',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    style: ButtonStyle(),
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.post
                                                            .commentWriterList
                                                            .add(token!);
                                                        widget.post.commentList
                                                            .add(
                                                                commentController
                                                                    .text);
                                                        commentController.text =
                                                            '';

                                                        fb_add_comment(
                                                            widget
                                                                .post.postTitle,
                                                            commentController
                                                                .text,
                                                            token!); // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자
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
                                                      Navigator.pop(context);
                                                    },
                                                  ))
                                            ]))));
                              });
                        })),
                for (int i = 0; i < widget.post.commentList.length; i++)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child:
                          Text("익명 ${i + 1} : ${widget.post.commentList[i]}"))
              ],
            )));
  }
}
