//https://picsum.photos/200/300   //  ⌘ ñ
//use lint
//import '../widget/detailscreen.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';
import 'home_page2.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'homepage',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
     
//routes: {  targetscreen.routeName:(ctx)=>targetscreen(),},
    );
  }
}
