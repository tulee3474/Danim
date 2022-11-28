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

String? token='';

class Login extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    // 차후에 웹버전을 위한 flag
    var _mobile = false;
    var _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    var _isAOS = Theme.of(context).platform == TargetPlatform.android;
    if(_isAOS || _isIOS) {
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
                  /*Text(
                    'Easy',
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(38, 100, 100, 1.0),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Icon(
                      Icons.star,
                      size: 50,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Text(
                    'Funny',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Play',
                    style:
                    TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Icon(
                      Icons.local_library,
                      size: 25,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Study',
                    style:
                    TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
              ),*/
// 구글 로그인
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  _mobile // 모바일 함수와 웹 함수가 다름
                      ? _handleSignIn().then((user) {
                    print('Google(AOS): login');
                    App();
                  })
                      : signInWithGoogleWeb().then((user) {
                    print('Google(Web): login');
                    App();
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),

// Email 로그인
              SignInButton(
                Buttons.Email,
                onPressed: () async {
                  print('------- Email authorization');
                  await Get.to(() => Email()); //widget.user
                },
              ),
            ],
          //),
        ),]
      ),
    )));
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
    token=user?.uid;
    userName=user?.displayName;
    userEmail=user?.email;
    return user;
  }

  Future signInWithGoogleWeb() async {
    // Create a new provider
    var googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    final authResult = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final user = authResult.user;
    token=user?.uid;
    userName=user?.displayName;
    userEmail=user?.email;
    return user;
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
          title: Text('Sign in with Email',
              style: TextStyle(color: Colors.white)
          ),
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
                    labelText: 'Email',
                  ),
                  controller: _email,
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0)),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
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
                        _login(email: _email.text.trim(), passWord: _passWd.text.trim());
                        App();
                      },
                      label: Text("Log in"),
                      icon: Icon(Icons.login),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Sign up --------------');
                        _signUp(email: _email.text.trim(), passWord: _passWd.text.trim());
                      },
                      label: Text("Sign up"),
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
      token=FirebaseAuth.instance.currentUser?.uid;
      userName=FirebaseAuth.instance.currentUser?.displayName;
      userEmail=FirebaseAuth.instance.currentUser?.email;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print(e.code.toString());
        myDialog(msg: "Wrong email or Wrong password");
      }
    }
  }
}

/*String? token='';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    print(data.toString());
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    token=user?.id.toString();
    print('${user?.id.toString()} 토큰');
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}*/