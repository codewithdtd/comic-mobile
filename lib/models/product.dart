
import 'package:flutter/foundation.dart';
class Product {
  final String? id;
  final String title;
  final String description;
  final String author;
  // final List<ChapterManager> chapter; 
  // final int price;
  final String imageUrl;
  late final String creatorId;
  final ValueNotifier<bool> _isFavorite;

  // int get chapterCount { 
  //   return chapter.length;
  // }


  Product({
    this.id,
    required this.title,
    required this.description,
    // required this.price,
    // required this.chapter,
    required this.imageUrl,
    required this.author,
    required this.creatorId,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);
  set isFavorite(bool newValue){
    _isFavorite.value = newValue;
  }
  bool get isFavorite {
    return _isFavorite.value;
  }
  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }
  Product copyWith({
    String? id,
    String? title,
    String? description,
    // List<Chapter>? chapter,
    String? author,
    String? imageUrl,
    bool? isFavorite,
    String? creatorId,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      // price: price ?? this.price,
      creatorId: creatorId ?? this.creatorId,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite, 
      // chapter: [] , 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
      'creatorId': creatorId,
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      creatorId: json['creatorId'],
      description: json['description'],
      author: json['author'],
      imageUrl: json['imageUrl'],
    );
  }
}

