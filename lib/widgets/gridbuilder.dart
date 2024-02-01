import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/data.dart';
import '../screens/details.dart';

class PetList extends StatefulWidget {
  final List<DataModel> foundList;
  final List<Color> selectedColor;
  const PetList({required this.foundList, required this.selectedColor, super.key});

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  final _myBox = Hive.box('pets');
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: widget.foundList.length,
        itemBuilder: (context, index) {
          // int randomIndex = Random().nextInt(colors.length);
          // Color randomColor = colors[randomIndex];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PetDetail(index: index,color: widget.selectedColor[index], foundList : widget.foundList)));
            },
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Hero(
                          tag: index,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.selectedColor[index],
                            ),
                            //child: Image.asset(_foundList[index].image, height: 100, width: 100,)
                            child: CachedNetworkImage(
                              imageUrl: widget.foundList[index].image,
                              placeholder: (context, url) => SizedBox(height:10,width:10, child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              Text(
                                widget.foundList[index].name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontFamily: 'WatchQuinn',
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$ ${widget.foundList[index].price}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                  fontFamily: 'WatchQuinn',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              Text(
                                "${widget.foundList[index].age} month old",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontFamily: 'WatchQuinn',
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                child: !_myBox.containsKey(widget.foundList[index].id) ?
                                Icon(Icons.check, color: Colors.green,):
                                Icon(Icons.close, color: Colors.red,),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _myBox.get(widget.foundList[index].id) == null ? false : true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Already Adopted',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18,
                              fontFamily: 'Arcon',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
