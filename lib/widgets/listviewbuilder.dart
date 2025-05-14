import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/data.dart';

class ListViewBuilder extends StatefulWidget {
  final List<Color> selectedColor;
  final List<DataModel> adoptedList;
  const ListViewBuilder(
      {required this.selectedColor, required this.adoptedList, super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.adoptedList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Card(
            color:
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: widget.selectedColor[index],
                    ),
                    // child: Image.asset(adoptedList[index].image, height: 100, width: 100,)
                    child: CachedNetworkImage(
                      imageUrl: widget.adoptedList[index].image,
                      placeholder: (context, url) => SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.adoptedList[index].name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontFamily: 'WatchQuinn',
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$ ${widget.adoptedList[index].price}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontFamily: 'WatchQuinn',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: Text(
                          widget.adoptedList[index].timestamp
                              .toString()
                              .substring(0, 10),
                          softWrap: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: Text(
                          "${widget.adoptedList[index].timestamp.hour}:${widget.adoptedList[index].timestamp.minute}:${widget.adoptedList[index].timestamp.second}",
                          softWrap: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                            fontFamily: 'AlbertSans',
                          ),
                        ),
                      )
                    ],
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
