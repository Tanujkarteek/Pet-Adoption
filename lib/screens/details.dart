import 'dart:math';

import 'package:adoption/constants/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:hive/hive.dart';
import 'package:quickalert/quickalert.dart';

import '../bloc/adopted/adopted_bloc.dart';
import '../widgets/herophotoview.dart';
import 'homescreen.dart';

class PetDetail extends StatefulWidget {
  final int index;
  final Color color;
  final List<DataModel> foundList;
  PetDetail({required this.index,required this.color,required this.foundList,super.key});

  @override
  State<PetDetail> createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  final ConfettiController _confettiController2 = ConfettiController(duration: const Duration(seconds: 5));

  final _myBox = Hive.box('pets');

  void _showPopUp(BuildContext context, int index) {
    //create a toast
    final scaffold = ScaffoldMessenger.of(context);
    QuickAlert.show(
        confirmBtnColor: Colors.black,
        context: context,
        type: QuickAlertType.success,
        text: 'You have Adopted ${widget.foundList[index].name}',
        onConfirmBtnTap: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
        }
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _confettiController2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    Color color = widget.color;
    List<DataModel> dataList = widget.foundList;

    final AdoptedBloc adoptionBloc = AdoptedBloc();
    return BlocConsumer<AdoptedBloc, AdoptedState>(
      bloc: adoptionBloc,
      listener: (context, state) {
        if (state is AdoptionExited) {
          Navigator.pop(context);
          print("Adoption Exited");
        }
        if (state is AdoptionInProgress){
          print("Adoption In Progress");
          AdoptionRequested(petId: dataList[index].id).updatePetAdoptionStatus(dataList[index].id);
          print("Adoption In Progress");
          adoptionBloc.add(AdoptionSuccess(petId: index));
        }
        if (state is AdoptionCompleted) {
          _confettiController.play();
          _confettiController2.play();
          _showPopUp(context, index);
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Stack(
                    // alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HeroPhotoViewRouteWrapper(
                                              imageProvider: CachedNetworkImageProvider(dataList[index].image),
                                              index: index,
                                              backgroundDecoration: BoxDecoration(
                                                color: color,
                                              )
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Hero(
                                          tag: index,
                                          child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(150),
                                                    bottomRight: Radius.circular(150),
                                                  ),
                                                  color: color,
                                                ),
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                width: MediaQuery.of(context).size.width,
                                                // child: Image(
                                                //     image: AssetImage(dataList[index].image),
                                                // ),
                                            child: CachedNetworkImage(
                                              imageUrl: dataList[index].image,
                                              placeholder: (context, url) => SizedBox(height:10,width:10, child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              height: 100,
                                              width: 100,
                                            ),
                                              ),
                                        ),
                                      ),
                                    ),
                                      Container(
                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.height*0.02),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.onBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          adoptionBloc.add(AdoptionExit());
                                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dataList[index].name,
                                          style: TextStyle(
                                            fontSize: 50,
                                            fontFamily: "WatchQuinn",
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "\$ ${dataList[index].price}",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: "WatchQuinn",
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.005,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0; i < dataList[index].tags.length; i++)
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left:5,right:5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              dataList[index].tags[i],
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onPrimary,
                                                fontSize: 20,
                                                fontFamily: "WatchQuinn",
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.02,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: color,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          height: MediaQuery.of(context).size.height * 0.08,
                                          child: Text(
                                            "${dataList[index].age} Months\nAge",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 20,
                                              fontFamily: "WatchQuinn",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color:  color,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          height: MediaQuery.of(context).size.height * 0.08,
                                          child: Text(
                                            "${dataList[index].gender} \nGender",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 20,
                                              fontFamily: "WatchQuinn",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.02,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    child: Text(
                                      lorem(paragraphs: 1, words: 5),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 20,
                                        fontFamily: "AlbertSans",
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.85,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  child: ElevatedButton(
                                    onPressed: () {
                                       if(!_myBox.containsKey(dataList[index].id)) {
                                         adoptionBloc.add(AdoptionRequested(petId: dataList[index].id));
                                       }
                                    },
                                    child: Text(
                                      "Adopt",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "WatchQuinn",
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _myBox.containsKey(dataList[index].id) ? color.withAlpha(10) : color.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                ConfettiWidget(
                    confettiController: _confettiController,
                  blastDirection: (-pi/3),
                  maxBlastForce: 60,
                  minBlastForce: 30,
                ),
                Spacer(),
                ConfettiWidget(
                    confettiController: _confettiController2,
                  blastDirection: (-2*(pi/3)),
                  maxBlastForce: 60,
                  minBlastForce: 30,
                ),
              ],
            ),
          ],
    );
  },
);
  }
}
