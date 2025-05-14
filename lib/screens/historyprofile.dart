import 'dart:math';

import 'package:adoption/bloc/adopted/adopted_bloc.dart';
import 'package:adoption/widgets/colorrandomizer.dart';
import 'package:adoption/widgets/listviewbuilder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'homescreen.dart';

class HistoryPage extends StatefulWidget {
  final List<DataModel> ownedList;
  const HistoryPage({required this.ownedList, super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _myBox = Hive.box('pets');

  late List<Color> selectedColor = [];

  void getAdoptedList() async {
    // Clear the existing elements in adoptedList before populating it
    adoptedList.clear();

    // Iterate through each key in _myBox
    _myBox.keys.forEach((element) {
      // Check if dataList contains the key
      if (_myBox.containsKey(element)) {
        // Retrieve the corresponding value from dataList and add it to adoptedList
        adoptedList.add(widget.ownedList[element]);

        // If you want to set a timestamp for the added item, you can do it here
        adoptedList.last.timestamp = _myBox.get(element);
      }
    });

    // If you want to sort adoptedList by timestamp, you can uncomment the line below
    adoptedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<DataModel> adoptedList = [];
  @override
  void initState() {
    getAdoptedList();
    selectedColor = ColorRandomizerInt(20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        onPressed: () {
          setState(() {
            _myBox.clear();
            context.read<AdoptedBloc>().add(AdoptionCleared());
            Navigator.pop(context);
          });
        },
        child: Icon(
          color: Theme.of(context).colorScheme.surface,
          Icons.delete,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ListViewBuilder(
              selectedColor: selectedColor,
              adoptedList: adoptedList,
            )
          ],
        ),
      ),
    );
  }
}

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "History",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
                Text(
                  "Latest First",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
