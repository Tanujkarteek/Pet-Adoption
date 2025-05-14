import 'dart:convert';
import 'package:adoption/widgets/pet_list.dart';
import 'package:adoption/widgets/header.dart';
import 'package:adoption/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/categorybar.dart';
import '../constants/data.dart';
import '../widgets/colorrandomizer.dart';
import 'filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late List<Color> selectedColor = [];
  late List<DataModel> fetchedList = [];
  List<DataModel> get foundList => _foundList;
  List<DataModel> _foundList = [];
  String selectedCategory = 'All';

  Future<List<DataModel>> fetchData() async {
    var url = 'https://testdataadoption.vercel.app/getdata';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        for (var data in data) {
          fetchedList.add(DataModel.fromJson(data));
        }
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
    return fetchedList;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        _foundList.addAll(value);
        selectedColor = ColorRandomizer(_foundList);
        isLoading =
            false; // Always set to false when done, regardless of success
      });
    }).catchError((error) {
      print('Error in fetchData: $error');
      setState(() {
        isLoading = false; // Always set to false when there's an error
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<DataModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = fetchedList;
    } else {
      results = fetchedList
          .where((pet) =>
              pet.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundList = results;
    });
  }

  void _runFilterTag(String enteredKeyword) {
    List<DataModel> results = [];
    if (enteredKeyword == 'All') {
      results = fetchedList;
    } else {
      results = fetchedList
          .where((pet) => pet.tags.contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundList = results;
      selectedCategory = enteredKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Theme.of(context).colorScheme.surface,
            statusBarIconBrightness:
                Theme.of(context).colorScheme.surface == Color(0xffF7F7F7)
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                HeaderBar(
                  adoptedList: _foundList,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.01),
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.05),
                                spreadRadius: .5,
                                blurRadius: .5,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) => _runFilter(value),
                            // controller: widget.controller,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontFamily: 'WatchQuinn',
                            ),
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 30,
                              ),
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontFamily: 'WatchQuinn'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          right: MediaQuery.of(context).size.width * 0.06),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                'Categories',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontFamily: 'WatchQuinn',
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  final updatedList = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FilterPage(foundList: fetchedList),
                                    ),
                                  );

                                  if (updatedList != null) {
                                    setState(() {
                                      _foundList = updatedList;
                                    });
                                  }
                                },
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                    fontFamily: 'WatchQuinn',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          //horizontal navigation bar using listview builder
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) {
                                final isSelected = categoryList[index].name ==
                                    selectedCategory;
                                return GestureDetector(
                                  onTap: () {
                                    _runFilterTag(categoryList[index].name);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.2)
                                            : Theme.of(context)
                                                .canvasColor
                                                .withAlpha(100),
                                        borderRadius: BorderRadius.circular(10),
                                        border: isSelected
                                            ? Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (categoryList[index].image !=
                                              'none')
                                            Image.asset(
                                              categoryList[index].image,
                                              height: 40,
                                              width: 40,
                                            ),
                                          if (categoryList[index].image !=
                                              'none')
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          Text(
                                            categoryList[index].name,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              fontSize: 16,
                                              fontFamily: 'WatchQuinn',
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                PetList(foundList: _foundList, selectedColor: selectedColor),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
