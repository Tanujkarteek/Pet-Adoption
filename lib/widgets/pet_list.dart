import 'package:adoption/bloc/adopted/adopted_bloc.dart';
import 'package:adoption/bloc/favorite/favorite_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/data.dart';
import '../screens/details.dart';

class PetList extends StatefulWidget {
  final List<DataModel> foundList;
  final List<Color> selectedColor;
  final bool isFavorite;
  const PetList({
    required this.foundList,
    required this.selectedColor,
    this.isFavorite = false,
    super.key,
  });

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  final _myBox = Hive.box('pets');
  final _myBox2 = Hive.box('favorites');
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return BlocConsumer<AdoptedBloc, AdoptedState>(
      bloc: context.read<AdoptedBloc>(),
      listener: (context, state) {
        if (state is AdoptionExited) {
          print("Adoption Exited");
        }
      },
      builder: (context, state) {
        return BlocConsumer<FavoriteBloc, FavoriteState>(
          bloc: context.read<FavoriteBloc>(),
          listener: (context, state) {
            if (state is FavoriteCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: Duration(milliseconds: 140),
                ),
              );
            }
            if (state is FavoriteFailed) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb
                    ? 4
                    : !isLandscape
                        ? 2
                        : 3,
                childAspectRatio: kIsWeb
                    ? 1.8
                    : !isLandscape
                        ? 0.8
                        : 1.3,
              ),
              itemCount: widget.foundList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetail(
                          index: index,
                          color: widget.selectedColor[index],
                          foundList: widget.foundList,
                          isFavorite: widget.isFavorite,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Hero(
                                tag: !widget.isFavorite ? index : "${index}fav",
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: widget.selectedColor[index],
                                  ),
                                  //child: Image.asset(_foundList[index].image, height: 100, width: 100,)
                                  child: CachedNetworkImage(
                                    imageUrl: widget.foundList[index].image,
                                    placeholder: (context, url) => SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    height: kIsWeb ? 130 : 100,
                                    width: kIsWeb ? 130 : 100,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: !isLandscape
                                      ? kIsWeb
                                          ? MediaQuery.of(context).size.width *
                                              0.02
                                          : 0
                                      : MediaQuery.of(context).size.width *
                                          0.02,
                                ),
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.foundList[index].name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 16,
                                        fontFamily: 'WatchQuinn',
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "\$${widget.foundList[index].price}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        fontFamily: 'WatchQuinn',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: !isLandscape
                                      ? kIsWeb
                                          ? MediaQuery.of(context).size.width *
                                              0.02
                                          : 0
                                      : MediaQuery.of(context).size.width *
                                          0.02,
                                ),
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Row(
                                  children: [
                                    Text(
                                      "${widget.foundList[index].age} month old",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 12,
                                        fontFamily: 'WatchQuinn',
                                      ),
                                    ),
                                    Spacer(),
                                    _myBox2.containsKey(
                                            widget.foundList[index].id)
                                        ? GestureDetector(
                                            onTap: () {
                                              context.read<FavoriteBloc>().add(
                                                    RemoveFavorite(
                                                      petId: widget
                                                          .foundList[index].id,
                                                      timestamp: DateTime.now(),
                                                    ),
                                                  );
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              size: 26,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              context.read<FavoriteBloc>().add(
                                                    AddFavorite(
                                                      petId: widget
                                                          .foundList[index].id,
                                                      timestamp: DateTime.now(),
                                                    ),
                                                  );
                                            },
                                            child: Icon(
                                              Icons.favorite_border_outlined,
                                              size: 26,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                _myBox.get(widget.foundList[index].id) == null
                                    ? false
                                    : true,
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
            );
          },
        );
      },
    );
  }
}
