import 'package:adoption/bloc/adopted/adopted_bloc.dart';
import 'package:adoption/bloc/favorite/favorite_bloc.dart';
import 'package:adoption/screens/homescreen.dart';
import 'package:adoption/theme/dark_theme.dart';
import 'package:adoption/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('pets');
  var box2 = await Hive.openBox('favorites');
  runApp(MultiBlocProvider(providers: [
    BlocProvider<FavoriteBloc>(
      create: (context) => FavoriteBloc(),
    ),
    BlocProvider<AdoptedBloc>(
      create: (context) => AdoptedBloc(),
    ),
  ], child: const MyApp()));
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
      },
      home: const HomeScreen(),
    );
  }
}
