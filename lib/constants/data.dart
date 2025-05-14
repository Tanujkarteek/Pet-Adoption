import 'dart:ui';

class DataModel {
  late String name;
  late String image;
  late List<String> tags;
  late int age;
  late String price;
  late String gender;
  late DateTime timestamp;
  late int id;

  DataModel(
      {required this.name, required this.image, required this.tags, required this.age, required this.price, required this.gender});

  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    tags = json['tags'].cast<String>();
    age = json['age'];
    price = json['price'];
    gender = json['gender'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['tags'] = this.tags;
    data['age'] = this.age;
    data['price'] = this.price;
    data['gender'] = this.gender;
    return data;
  }
}

// List<DataModel> dataList = [
//   DataModel(name: 'Max', image: 'assets/images/cat1.png', tags: ['cat','old'], age: 12, price: '100', gender: 'Male'),
//   DataModel(name: 'Jasper', image: 'assets/images/dog5.png', tags: ['dog','young'], age: 5, price: '900', gender:  'Male'),
//   DataModel(name: 'Saffron', image: 'assets/images/bird5.png', tags: ['parrot','young'], age: 6, price: '4500', gender:  'Female'),
//   DataModel(name: 'Garfield', image: 'assets/images/cat2.png', tags: ["cat", "young", "lazy"], age: 2, price: '1000', gender: 'Female'),
//   DataModel(name: 'Johnny', image: 'assets/images/dog1.png', tags: ['dog','old'], age: 16, price: '200', gender:  'Male'),
//   DataModel(name: 'Blu', image: 'assets/images/bird4.png', tags: ['parrot','young'], age: 6, price: '4500', gender:  'Female'),
//   DataModel(name: 'Kiko', image: 'assets/images/bird3.png', tags: ['parrot','young'], age: 4, price: '5000', gender:  'Male'),
//   DataModel(name: 'Stephen', image: 'assets/images/cat3.png', tags: ['cat', 'pet'], age: 1, price: '500', gender: 'Male'),
//   DataModel(name: 'Bella', image: 'assets/images/dog3.png', tags: ['dog','young'], age: 16, price: '500', gender:  'Female'),
//   DataModel(name: 'Henry', image: 'assets/images/cat4.png', tags: ['cat', 'pet'], age: 3, price: '2000', gender: 'Male'),
//   DataModel(name: 'Cooper', image: 'assets/images/dog6.png', tags: ['dog','old'], age: 12, price: '600', gender:  'Male'),
//   DataModel(name: 'Coco', image: 'assets/images/bird6.png', tags: ['parrot','old'], age: 20, price: '3500', gender:  'Male'),
//   DataModel(name: 'Max', image: 'assets/images/cat5.png', tags: ['cat','old'], age: 12, price: '100', gender: 'Female'),
//   DataModel(name: 'Tucker', image: 'assets/images/dog2.png', tags: ['dog','young'], age: 4, price: '800', gender:  'Male'),
//   DataModel(name: 'Lucy', image: 'assets/images/dog4.png', tags: ['dog','old'], age: 14, price: '500', gender:  'Female'),
//   DataModel(name: 'Pepper', image: 'assets/images/bird1.png', tags: ['parrot','old'], age: 16, price: '2100', gender:  'Female'),
//   DataModel(name: 'Garfield', image: 'assets/images/cat6.png', tags: ['cat', 'pet'], age: 2, price: '1000', gender: 'Male'),
//   DataModel(name: 'Rio', image: 'assets/images/bird2.png', tags: ['parrot','young'], age: 6, price: '4500', gender:  'Male'),
// ];