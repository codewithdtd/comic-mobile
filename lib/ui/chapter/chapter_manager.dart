import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/chapter.dart';
import '../../models/auth_token.dart';
import '../../services/chapters_service.dart';

class ChapterManager with ChangeNotifier {
  // final List<Chapter> _items = [
  //   Chapter(
  //     id: 'c1',
  //     title: 'Chương 1',
  //     productId: 'p1',
  //     image: [
  //       'https://i3.bumcheo2.info/240/240924/001-p2j.jpg',
  //       'https://i3.bumcheo2.info/240/240924/004.jpg',
  //       'https://i3.bumcheo2.info/240/240924/006.jpg',
  //       'https://i3.bumcheo2.info/240/240924/007.jpg',
  //       'https://i3.bumcheo2.info/240/240924/008.jpg',
  //       'https://i3.bumcheo2.info/240/240924/010.jpg',
  //       'https://i3.bumcheo2.info/240/240924/011.jpg',
  //       'https://i3.bumcheo2.info/240/240924/012.jpg',
  //       'https://i3.bumcheo2.info/240/240924/013.jpg',
  //     ], 
  //     content: ''
  //   ),
  //   Chapter(
  //     id: 'c2',
  //     title: 'Chương 2',
  //     productId: 'p1',
  //     // imageUrl:
  //     // 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //     image: [
  //       'https://i3.bumcheo2.info/253/253568/001-p2j.jpg',
  //       'https://i3.bumcheo2.info/253/253568/002-p2j.jpg',
  //       'https://i3.bumcheo2.info/253/253568/003-copy-p2j.jpg',
  //       'https://i3.bumcheo2.info/253/253568/004-copy-p2j.jpg',
  //       'https://i3.bumcheo2.info/253/253568/005-copy-p2j.jpg',
  //     ], 
  //     content: ''
  //   ),
  //   Chapter(
  //     id: 'c1p',
  //     title: 'Chương 1',
  //     productId: 'p2',
  //     // imageUrl:
  //     // 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //     image: [
  //       'https://i4.bumcheo2.info/313/313702/02-1.jpg',
  //       'https://i4.bumcheo2.info/313/313702/03-1-p2j.jpg',
  //       'https://i4.bumcheo2.info/313/313702/04-1-p2j.jpg',
  //     ], 
  //     content: ''
  //   ),
  // ];

  List<Chapter> _items = [];

  final ChaptersService _chaptersService;

  int get chapterCount {
    return _items.length;
  }
  // List<Chapter> get items {
  //   return _items.values.toList();
  // }
  List<Chapter> get items {
    return [..._items];
  }

  List<Chapter> getChaptersByProductId(String? productId) {
    return _items.where((chapter) => chapter.productId == productId).toList();
  }

  Chapter? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  ChapterManager([AuthToken? authToken])
      : _chaptersService = ChaptersService(authToken);

  set authToken(AuthToken? authToken) {
    _chaptersService.authToken = authToken;
  }

  Future<void> fetchChapters() async {
    _items = await _chaptersService.fetchChapters();
    notifyListeners();
  }

  Future<void> fetchUserChapters() async {
    _items = await _chaptersService.fetchChapters(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addChapter(Chapter chapter) async {
    final newChapter = await _chaptersService.addchapter(chapter);
    if(newChapter != null) {
      _items.add(newChapter);
      notifyListeners();
    }
  }

  void updateChapterDetail(Chapter chapter){
    final index =_items.indexWhere((item)=>item.id== chapter.id);
    if(index >=0){
      final updatedChapter = _items[index].copyWith(
        image: chapter.image,
      );
      _items[index] = updatedChapter;
      notifyListeners();
    }
  }

  Future<void> updateChapter(Chapter chapter) async {
    final index =_items.indexWhere((item)=>item.id== chapter.id);
    if(index >=0){
      if(await _chaptersService.updatechapter(chapter)) {
        _items[index]=chapter;
        notifyListeners();
      }
    }
  }

  Future<void> deleteChapter(String id) async {
    final index = _items.indexWhere((item)=> item.id== id);
    Chapter? existingChapter = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if(!await _chaptersService.deletechapter(id)) {
      _items.insert(index, existingChapter);
      notifyListeners();
    }
  }

  Future<void> deleteChapterWithProduct(String productId) async {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].productId == productId) {
        deleteChapter(_items[i].id.toString());
      }
    }
    notifyListeners();
    
  }
}