import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants/data.dart';
import '../widgets/pet_list.dart';
import '../widgets/colorrandomizer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _myBox2 = Hive.box('favorites');
  late List<DataModel> favoriteList = [];
  late List<Color> selectedColor = [];
  bool isLoading = true;

  Future<List<DataModel>> fetchData() async {
    var url = 'https://testdataadoption.vercel.app/getdata';
    var response = await http.get(Uri.parse(url));
    List<DataModel> allPets = [];
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var pet in data) {
        allPets.add(DataModel.fromJson(pet));
      }
    }
    return allPets;
  }

  void _loadFavorites() async {
    final allPets = await fetchData();
    final favoriteIds = _myBox2.keys.toList();

    setState(() {
      favoriteList =
          allPets.where((pet) => favoriteIds.contains(pet.id)).toList();
      selectedColor = ColorRandomizer(favoriteList);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontFamily: 'WatchQuinn',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (favoriteList.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                      fontFamily: 'WatchQuinn',
                    ),
                  ),
                ),
              )
            else
              PetList(
                foundList: favoriteList,
                selectedColor: selectedColor,
                isFavorite: true,
              ),
          ],
        ),
      ),
    );
  }
}
