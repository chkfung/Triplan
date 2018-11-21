import 'package:flutter/material.dart';

import 'screen/home.dart';
import 'screen/onboarding.dart';

class TriplanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Triplan',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnBoardingPage(),
        '/home': (context) => HomePage(),
      },
//      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
