import 'dart:convert';
import 'dart:math';

import 'package:adoption/widgets/gridbuilder.dart';
import 'package:adoption/widgets/header.dart';
import 'package:adoption/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../constants/categorybar.dart';
import '../constants/colors.dart';
import '../constants/data.dart';
import '../widgets/colorrandomizer.dart';
import 'details.dart';
import 'filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late List<Color> selectedColor =[];
  late List<DataModel> fetchedList = [];
  List<DataModel> get foundList => _foundList;
  List<DataModel> _foundList = [];

  Future<List<DataModel>> fetchData() async {
    var url = 'https://testdataadoption.vercel.app/getdata';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      for(var data in data) {
        fetchedList.add(DataModel.fromJson(data));
      }
    } else {
      print(response.statusCode);
    }
    return fetchedList;
  }

  @override
  void initState() {
    fetchData().then((value) {
      setState(() {
        _foundList.addAll(value);
        selectedColor = ColorRandomizer(_foundList);
        isLoading = !isLoading;
      });
      //(value);
    });
    super.initState();
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
          .where((pet) =>
          pet.tags.contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundList = results;
    });

  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlayWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Theme.of(context).colorScheme.background,
            statusBarIconBrightness: Theme.of(context).colorScheme.background == Color(0xffF7F7F7) ? Brightness.dark : Brightness.light,
          ),
          child: SafeArea(
            child: Column(
              children:<Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                HeaderBar(adoptedList: _foundList,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.01),
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(.05),
                                spreadRadius: .5,
                                blurRadius: .5,
                                offset: Offset(0, 1), // changes position of shadow
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
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 30,),
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 20, fontFamily: 'WatchQuinn'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06),
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
                                  //_foundList.clear();
                                  final updatedList = await Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage(foundList:fetchedList)));

                                  if(updatedList != null) {
                                   // print(updatedList.length);
                                    setState(() {
                                      // _foundList.clear();
                                      _foundList = updatedList;
                                    });
                                  }
                                },
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
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
                                return GestureDetector(
                                  onTap: () {
                                    _runFilterTag(categoryList[index].name);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.05,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor.withAlpha(100),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(categoryList[index].image != 'none')
                                            Image.asset(categoryList[index].image, height: 40, width: 40,),
                                          if(categoryList[index].image != 'none')
                                            const SizedBox(width: 10,),
                                          Text(
                                            categoryList[index].name,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 16,
                                              fontFamily: 'WatchQuinn',
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
