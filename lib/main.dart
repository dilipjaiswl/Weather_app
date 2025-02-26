import 'package:flutter/material.dart';
import 'package:wheather_app/screens/wheather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,),
      // ).copyWith(
      //   appBarTheme: AppBarTheme(color: Colors.deepOrange)
      // ),
      home: const WeatherScreen(),
    );
  }
}

