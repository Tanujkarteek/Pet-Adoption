import 'package:adoption/screens/favorites.dart';
import 'package:flutter/material.dart';

import '../constants/data.dart';
import '../screens/historyprofile.dart';

class HeaderBar extends StatefulWidget {
  final List<DataModel> adoptedList;
  const HeaderBar({required this.adoptedList, super.key});

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: const Image(
            image: AssetImage('assets/icon/union.png'),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: Text(
            'Welcome',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 28,
              fontFamily: 'Galorine',
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()));
          },
          icon: Icon(Icons.favorite),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HistoryPage(ownedList: widget.adoptedList)));
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/face.png'),
            ),
          ),
        ),
      ],
    );
  }
}
