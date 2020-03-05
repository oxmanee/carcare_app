import 'package:booking_carcare_app/pages/booking.dart';
import 'package:booking_carcare_app/pages/history.dart';
import 'package:booking_carcare_app/pages/home.dart';
import 'package:booking_carcare_app/pages/login.dart';
import 'package:booking_carcare_app/pages/profile_member.dart';
//import 'package:booking_carcare_app/pages/profile.dart';
import 'package:booking_carcare_app/pages/regis.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        '/main': (context) => LoginPage(),
        '/regis': (context) => RegisPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/booking': (context) => BookingPage(),
        '/history': (context) => HistoryPage()
      },
    );
  }
}
