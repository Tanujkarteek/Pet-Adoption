import 'package:adoption/bloc/adopted/adopted_bloc.dart';
import 'package:adoption/bloc/favorite/favorite_bloc.dart';
import 'package:adoption/bloc/theme/theme_bloc.dart';
import 'package:adoption/repository/pet_repository.dart';
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
  var settings = await Hive.openBox('settings');

  // Create pet repository
  final petRepository = PetRepository();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<FavoriteBloc>(
      create: (context) => FavoriteBloc(),
    ),
    BlocProvider<AdoptedBloc>(
      create: (context) => AdoptedBloc(),
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc()..add(ThemeInitialized()),
    ),
  ], child: MyApp(petRepository: petRepository)));
}

class MyApp extends StatelessWidget {
  final PetRepository petRepository;

  const MyApp({super.key, required this.petRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Adoption',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: state.themeMode,
        routes: {
          '/home': (context) => HomeScreen(repository: petRepository),
        },
        home: HomeScreen(repository: petRepository),
      );
    });
  }
}
