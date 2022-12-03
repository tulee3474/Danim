import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/image_data.dart';
import 'community.dart';
import 'login.dart';

class NewPost extends StatefulWidget{

  NewPost();

  @override
  _NewPostState createState() => _NewPostState();

}

class _NewPostState extends State<NewPost>{

  Post newPost = Post(
    '',
    posts.length,
    '',
    [],[],[],0,''
  );

  TextEditingController postTitleController = TextEditingController();
  //TextEditingController postWriterController = TextEditingController();
  TextEditingController postContentController = TextEditingController();


  @override
  initState(){
    super.initState();
    postTitleController = TextEditingController();
    postContentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
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
          children:[

            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("새로운 글")),
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(color: Colors.grey, thickness: 2.0)),

            TextField(
              controller: postTitleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '글 제목'),
            ),
            TextField(
              controller: postContentController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '글 내용'),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0,20,0,0),
              child: ElevatedButton(child: Text('글 저장',
                  style: TextStyle(color: Colors.black)),
                style: ButtonStyle(
                ),
                onPressed: () {

                  setState(() {
                    posts.add(Post(
                      postTitleController.text,
                      posts.length,
                        token,
                      [],[],[],0,postContentController.text
                    ));
                  });

                  //잘 들어갔나 확인

                  print(posts[posts.length-1].postTitle);
                  print(posts[posts.length-1].postWriter);
                  print(posts[posts.length-1].postContent);

                  //여기서 DB에 저장




                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Community()));

                },
              )
            )

          ]
        )
      )
    );
  }

}