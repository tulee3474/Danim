import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/src/app.dart' as app;
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
import 'package:danim/src/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';

String? token = '';

class Login extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // 차후에 웹버전을 위한 flag
    var _mobile = false;
    var _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    var _isAOS = Theme.of(context).platform == TargetPlatform.android;
    if (_isAOS || _isIOS) {
      _mobile = true;
    }

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Danim',
                  style: TextStyle(
                      fontSize: 40,
                      color: Color.fromRGBO(38, 100, 100, 1.0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
            ),
// 구글 로그인
            ElevatedButton(
              onPressed: () {
                _mobile // 모바일 함수와 웹 함수가 다름
                    ? _handleSignIn().then((user) {
                        print('Google(AOS): login');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => App()));
                      })
                    : signInWithGoogleWeb().then((user) {
                        print('Google(Web): login');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => App()));
                      });
              },
              child: Row(
                //spaceEvenly: 요소들을 균등하게 배치하는 속성
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/google_logo.png'),
                  Text(
                    '구글 로그인',
                    style: TextStyle(color: Colors.black87, fontSize: 15.0),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Image.asset('assets/images/google_logo.png'),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                //shadowColor: Colors.black, 그림자 추가하는 속성

                minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    // shape : 버튼의 모양을 디자인 하는 기능
                    borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
// Email 로그인
            ElevatedButton(
              onPressed: () async {
                await Get.to(() => Email()); //widget.user
              },
              child: Row(
                //spaceEvenly: 요소들을 균등하게 배치하는 속성
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/mail_logo.png'),
                  Text(
                    '이메일 로그인',
                    style: TextStyle(color: Colors.black87, fontSize: 15.0),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Image.asset('assets/images/mail_logo.png'),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                //shadowColor: Colors.black, 그림자 추가하는 속성

                minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    // shape : 버튼의 모양을 디자인 하는 기능
                    borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
//익명로그인
            ElevatedButton(
              onPressed: () async {
                await signInAnon();

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => App()));
              },
              child: Row(
                //spaceEvenly: 요소들을 균등하게 배치하는 속성
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/guest_logo.png'),
                  Text(
                    '익명 로그인',
                    style: TextStyle(color: Colors.black87, fontSize: 15.0),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Image.asset('assets/images/guest_logo.png'),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                //shadowColor: Colors.black, 그림자 추가하는 속성

                minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    // shape : 버튼의 모양을 디자인 하는 기능
                    borderRadius: BorderRadius.circular(4.0)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
          //),
        ),
      ),
    ));
  }

  Future _handleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;
    print(user);
    token = user?.uid;
    userName = user?.displayName;
    userEmail = user?.email;
    return user;
  }

  Future signInWithGoogleWeb() async {
    // Create a new provider
    var googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    final authResult =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final user = authResult.user;
    token = user?.uid;
    userName = user?.displayName;
    userEmail = user?.email;
    return user;
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      token=user?.uid;
      userName='익명 로그인';
      userEmail=' ';
      print('asdf $token');
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

// 이메일 로그인 및 가입화면
class Email extends StatefulWidget {
  @override
  EmailState createState() => EmailState();
}

class EmailState extends State<Email> {
  final _email = TextEditingController();
  final _passWd = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _passWd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(38, 100, 100, 1.0),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('이메일로 로그인', style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일',
                  ),
                  controller: _email,
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0)),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호',
                  ),
                  controller: _passWd,
                  obscureText: true,
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Log in --------------');
                        _login(
                            email: _email.text.trim(),
                            passWord: _passWd.text.trim());
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                        //Navigator.push(context,
                        //    MaterialPageRoute(builder: (context) => App()));
                      },
                      label: Text("로그인"),
                      icon: Icon(Icons.login),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Sign up --------------');
                        _signUp(
                            email: _email.text.trim(),
                            passWord: _passWd.text.trim());
                        _login(
                            email: _email.text.trim(),
                            passWord: _passWd.text.trim());
                        //Navigator.push(context,
                        //    MaterialPageRoute(builder: (context) => Email()));
                      },
                      label: Text("회원가입"),
                      icon: Icon(Icons.edit),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void myDialog({required String msg}) {
    Get.defaultDialog(
      title: "Notice",
      middleText: msg,
      backgroundColor: Colors.blue,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
    );
  }

  void _signUp({required String email, required String passWord}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passWord)
          .then((value) => Get.back(result: value));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        myDialog(msg: 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        myDialog(msg: 'The account already exists for that email');
      }
    } catch (e) {
      print('기타오류' + e.toString());
      myDialog(msg: e.toString());
    }
//
  }

  void _login({required String email, required String passWord}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passWord)
          .then((value) => Get.back(result: value));
      token = FirebaseAuth.instance.currentUser?.uid;
      //userName=FirebaseAuth.instance.currentUser?.uid;
      userName = FirebaseAuth.instance.currentUser?.email;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print(e.code.toString());
        myDialog(msg: "Wrong email or Wrong password");
      }
    }
  }
}
