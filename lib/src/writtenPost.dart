import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/src/community.dart';

import '../components/image_data.dart';

class WrittenPost extends StatefulWidget {
  Post post = Post('', 0, '', [], [], [], 0, '');

  WrittenPost(this.post);

  @override
  _WrittenPostState createState() => _WrittenPostState();
}

class _WrittenPostState extends State<WrittenPost> {

  TextEditingController commentWriterController = TextEditingController();
  TextEditingController commentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.monitor_heart),
        onPressed: () {
          setState(() {
            widget.post.recommendNum ++;
            widget.post.recommendList.add('좋아요1인');
          });
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
                    child: Text("작성자 : ${widget.post.postWriter}")),
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
                      style: ButtonStyle(
                          ),
                      onPressed: () {

                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context){
                              return AlertDialog(
                                  content: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: commentWriterController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(), labelText: '작성자 이름'),
                                            ),
                                            TextField(
                                              controller: commentController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(), labelText: '댓글 내용'),
                                           ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                              child: ElevatedButton(child: Text('댓글 작성',
                                                  style: TextStyle(color: Colors.black)),
                                                style: ButtonStyle(
                                                ),
                                                onPressed: () {

                                                setState(() {
                                                  widget.post.commentWriterList.add(commentWriterController.text);
                                                  widget.post.commentList.add(commentController.text);
                                                });

                                                //잘 들어갔나 확인
                                                print(widget.post.commentList[widget.post.commentList.length-1]);
                                                print(widget.post.commentWriterList[widget.post.commentWriterList.length-1]);

                                                //여기서 DB에 저장

                                                },
                                              )
                                            )




                                          ]
                                        )
                                      )
                                  )
                              );
                            }
                        );

                      })

                  ),


                for (int i = 0; i < widget.post.commentList.length; i++)
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                          "${widget.post.commentWriterList[i]} : ${widget.post.commentList[i]}"))
              ],
            )));
  }
}
