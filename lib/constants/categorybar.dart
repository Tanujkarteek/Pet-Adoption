class Category {
  late String name;
  late String image;

  Category({required this.name, required this.image});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}


List<Category> categoryList = [
  Category(name: 'All', image: 'none'),
  Category(name: 'Dog', image: 'assets/images/dog.png'),
  Category(name: 'Cat', image: 'assets/images/cat.png'),
  Category(name: 'Parrot', image: 'assets/images/parrot.png'),
];