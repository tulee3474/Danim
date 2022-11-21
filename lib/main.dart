// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
////파란 줄을 없애기 위한 빠른 수정

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:danim/src/app.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Danim (다님)',
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.black),
          )),
      home: App(),
      //home: const Map(),
      //home: const MyHomePage(),
    );
  }
}
