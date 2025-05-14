import 'dart:convert';
import 'package:adoption/bloc/adopted/adopted_bloc.dart';
import 'package:adoption/repository/pet_repository.dart';
import 'package:adoption/repository/pet_repository_interface.dart';
import 'package:adoption/widgets/pet_list.dart';
import 'package:adoption/widgets/header.dart';
import 'package:adoption/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/categorybar.dart';
import '../constants/data.dart';
import '../widgets/colorrandomizer.dart';
import 'filter.dart';

class HomeScreen extends StatefulWidget {
  final PetRepositoryInterface? repository;

  const HomeScreen({super.key, this.repository});

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
  final ScrollController _scrollController = ScrollController();
  // Repository instance with default implementation if not provided
  late final PetRepositoryInterface _petRepository;

  // Method to handle refresh action
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch fresh data using repository
    List<DataModel> freshData = await _petRepository.refreshPets();

    setState(() {
      fetchedList = freshData;
      _foundList = freshData;
      selectedColor = ColorRandomizer(_foundList);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _petRepository = widget.repository ?? PetRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final pets = await _petRepository.fetchPets();
      setState(() {
        _foundList = pets;
        fetchedList = pets;
        selectedColor = ColorRandomizer(_foundList);
        isLoading = false;
      });
    } catch (error) {
      print('Error in loadData: $error');
      setState(() {
        isLoading = false;
      });
    }
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return LoadingOverlayWidget(
      isLoading: isLoading,
      child: BlocListener(
        bloc: context.read<AdoptedBloc>(),
        listener: (context, state) {
          if (state is AdoptionClearedState) {
            print("Adoption Cleared");
            _refreshData();
          }
        },
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
                children: [
                  // Fixed header section
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  HeaderBar(
                    adoptedList: _foundList,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // Fixed search bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Container(
                      height: !isLandscape
                          ? MediaQuery.of(context).size.height * 0.06
                          : MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white30),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.05),
                            spreadRadius: .5,
                            blurRadius: .5,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _runFilter,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // Fixed category section
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
                          height: !isLandscape
                              ? MediaQuery.of(context).size.height * 0.05
                              : MediaQuery.of(context).size.height * 0.1,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  categoryList[index].name == selectedCategory;
                              return GestureDetector(
                                onTap: () {
                                  _runFilterTag(categoryList[index].name);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.03),
                                  child: Container(
                                    height: !isLandscape
                                        ? MediaQuery.of(context).size.height *
                                            0.05
                                        : MediaQuery.of(context).size.height *
                                            0.08,
                                    width: !isLandscape
                                        ? MediaQuery.of(context).size.width *
                                            0.3
                                        : MediaQuery.of(context).size.width *
                                            0.15,
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
                                        if (categoryList[index].image != 'none')
                                          Image.asset(
                                            categoryList[index].image,
                                            height: 40,
                                            width: 40,
                                          ),
                                        if (categoryList[index].image != 'none')
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  // Scrollable pet list section with RefreshIndicator
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: <Widget>[
                          PetList(
                              foundList: _foundList,
                              selectedColor: selectedColor),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
