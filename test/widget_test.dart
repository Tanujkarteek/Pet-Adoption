import 'package:adoption/constants/data.dart';
import 'package:adoption/main.dart';
import 'package:adoption/screens/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<DataModel> dataList = [
  DataModel(
      name: 'Max',
      image: 'assets/images/cat1.png',
      tags: ['cat', 'old'],
      age: 12,
      price: '100',
      gender: 'Male'),
  DataModel(
      name: 'Jasper',
      image: 'assets/images/dog5.png',
      tags: ['dog', 'young'],
      age: 5,
      price: '900',
      gender: 'Male'),
  DataModel(
      name: 'Saffron',
      image: 'assets/images/bird5.png',
      tags: ['parrot', 'young'],
      age: 6,
      price: '4500',
      gender: 'Female'),
  DataModel(
      name: 'Garfield',
      image: 'assets/images/cat2.png',
      tags: ["cat", "young", "lazy"],
      age: 2,
      price: '1000',
      gender: 'Female'),
  DataModel(
      name: 'Johnny',
      image: 'assets/images/dog1.png',
      tags: ['dog', 'old'],
      age: 16,
      price: '200',
      gender: 'Male'),
  DataModel(
      name: 'Blu',
      image: 'assets/images/bird4.png',
      tags: ['parrot', 'young'],
      age: 6,
      price: '4500',
      gender: 'Female'),
  DataModel(
      name: 'Kiko',
      image: 'assets/images/bird3.png',
      tags: ['parrot', 'young'],
      age: 4,
      price: '5000',
      gender: 'Male'),
  DataModel(
      name: 'Stephen',
      image: 'assets/images/cat3.png',
      tags: ['cat', 'pet'],
      age: 1,
      price: '500',
      gender: 'Male'),
  DataModel(
      name: 'Bella',
      image: 'assets/images/dog3.png',
      tags: ['dog', 'young'],
      age: 6,
      price: '500',
      gender: 'Female'),
  DataModel(
      name: 'Henry',
      image: 'assets/images/cat4.png',
      tags: ['cat', 'pet'],
      age: 3,
      price: '2000',
      gender: 'Male'),
  DataModel(
      name: 'Cooper',
      image: 'assets/images/dog6.png',
      tags: ['dog', 'old'],
      age: 12,
      price: '600',
      gender: 'Male'),
  DataModel(
      name: 'Coco',
      image: 'assets/images/bird6.png',
      tags: ['parrot', 'old'],
      age: 20,
      price: '3500',
      gender: 'Male'),
  DataModel(
      name: 'Max',
      image: 'assets/images/cat5.png',
      tags: ['cat', 'old'],
      age: 12,
      price: '100',
      gender: 'Female'),
  DataModel(
      name: 'Tucker',
      image: 'assets/images/dog2.png',
      tags: ['dog', 'young'],
      age: 4,
      price: '800',
      gender: 'Male'),
  DataModel(
      name: 'Lucy',
      image: 'assets/images/dog4.png',
      tags: ['dog', 'old'],
      age: 14,
      price: '500',
      gender: 'Female'),
  DataModel(
      name: 'Pepper',
      image: 'assets/images/bird1.png',
      tags: ['parrot', 'old'],
      age: 16,
      price: '2100',
      gender: 'Female'),
  DataModel(
      name: 'Garfield',
      image: 'assets/images/cat6.png',
      tags: ['cat', 'pet'],
      age: 2,
      price: '1000',
      gender: 'Male'),
  DataModel(
      name: 'Rio',
      image: 'assets/images/bird2.png',
      tags: ['parrot', 'young'],
      age: 6,
      price: '4500',
      gender: 'Male'),
];

void main() {
  testWidgets('Find Price Slider', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        // Wrap your widget with MaterialApp for testing
        home: FilterPage(foundList: dataList),
      ),
    );
    var priceSlider = find.byType(RangeSlider).first;
    expect(priceSlider, findsOneWidget);
  });
  testWidgets('Find Age Slider', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        // Wrap your widget with MaterialApp for testing
        home: FilterPage(foundList: dataList),
      ),
    );
    var ageSlider = find.byType(RangeSlider).last;
    expect(ageSlider, findsOneWidget);
  });
}
