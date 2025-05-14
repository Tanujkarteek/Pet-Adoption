import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/data.dart';

class FilterPage extends StatefulWidget {
  late List<DataModel> foundList = [];
  FilterPage({required this.foundList, super.key});

  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  RangeValues _currentPriceValues = const RangeValues(0, 5000);
  RangeValues _currentAgeValues = const RangeValues(0, 20);

  void _runFilter() async {
    // print("_currentPriceValues: ${_currentPriceValues.start}-${_currentPriceValues.end}");
    // print("_currentAgeValues: ${_currentAgeValues.start}-${_currentAgeValues.end}");
    //take the start and end from both range values and use them to filter dataLIst and place those values in foundList
    List<DataModel> foundList = [];
    //print(foundList.length);
    for (var i = 0; i < widget.foundList.length; i++) {
      //print(int.parse(dataList[i].price));
      if (int.parse(widget.foundList[i].price) >=
              _currentPriceValues.start.toInt() &&
          int.parse(widget.foundList[i].price) <=
              _currentPriceValues.end.toInt() &&
          widget.foundList[i].age >= _currentAgeValues.start.toInt() &&
          widget.foundList[i].age <= _currentAgeValues.end.toInt()) {
        // Check if the item is not already in foundList
        if (!foundList.contains(widget.foundList[i])) {
          foundList.add(widget.foundList[i]);
        }
      }
    }

    print(foundList.length);
    Navigator.pop(context, foundList);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget priceFilter() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Price Range Selector',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontFamily: 'WatchQuinn',
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RangeSlider(
              activeColor: Theme.of(context).colorScheme.primary,
              values: _currentPriceValues,
              max: 5000,
              divisions: 50,
              min: 0,
              labels: RangeLabels(
                _currentPriceValues.start.round().toString(),
                _currentPriceValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentPriceValues = values;
                });
                setPrice(values, widget.foundList);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Text(
                  'Min\n\$${_currentPriceValues.start.round()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
                Spacer(),
                Text(
                  'Max\n\$${_currentPriceValues.end.round()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
            ),
          ),
        ],
      );
    }

    Widget ageFilter() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Age Range Selector',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontFamily: 'WatchQuinn',
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RangeSlider(
              activeColor: Theme.of(context).colorScheme.primary,
              values: _currentAgeValues,
              max: 20,
              divisions: 20,
              min: 0,
              labels: RangeLabels(
                _currentAgeValues.start.round().toString(),
                _currentAgeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentAgeValues = values;
                });
                setAge(values, widget.foundList);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Text(
                  'Min\n${_currentAgeValues.start.round()} months',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
                Spacer(),
                Text(
                  'Max\n${_currentAgeValues.end.round()} months',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontFamily: 'WatchQuinn',
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
            ),
          ),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Filter',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 26,
                          fontFamily: 'WatchQuinn',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isLandscape ? 40 : 80),
                Expanded(
                  child: isLandscape
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: priceFilter()),
                            Expanded(child: ageFilter()),
                          ],
                        )
                      : Column(
                          children: [
                            priceFilter(),
                            SizedBox(height: 30),
                            ageFilter(),
                          ],
                        ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.05
                      : isLandscape
                          ? MediaQuery.of(context).size.height * 0.08
                          : MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    onPressed: _runFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontFamily: 'WatchQuinn',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int setPrice(RangeValues values, List<DataModel> dataList) {
  int numberItem = 0;
  //iterate the list and find the number of items that are in the range
  for (var i = 0; i < dataList.length; i++) {
    if (int.parse(dataList[i].price) >= values.start.toInt() &&
        int.parse(dataList[i].price) <= values.end.toInt()) {
      numberItem++;
    }
  }
  return numberItem;
}

int setAge(RangeValues values, List<DataModel> dataList) {
  int numberItem = 0;
  //iterate the list and find the number of items that are in the range
  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i].age >= values.start.toInt() &&
        dataList[i].age <= values.end.toInt()) {
      numberItem++;
    }
  }
  return numberItem;
}
