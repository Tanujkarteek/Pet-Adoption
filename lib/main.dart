import 'package:adoption/screens/details.dart';
import 'package:adoption/screens/filter.dart';
import 'package:adoption/screens/historyprofile.dart';
import 'package:adoption/screens/homescreen.dart';
import 'package:adoption/theme/dark_theme.dart';
import 'package:adoption/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  await Hive.initFlutter();

  var box = await Hive.openBox('pets');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption',
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        '/home': (context) => const HomeScreen(),
        //'/details': (context) => PetDetail(),
      },
      home: const HomeScreen(),
    );
  }
}