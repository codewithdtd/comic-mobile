import 'dart:convert';
import '../models/chapter.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class ChaptersService extends FirebaseService {
  ChaptersService([AuthToken? authToken]): super(authToken);

  Future<List<Chapter>> fetchChapters({bool filteredByUser = false}) async { 
    final List<Chapter> chapters = [];

    try {
      final filters =
        filteredByUser? 'orderBy="creatorId"&equalTo="$userId"' : '';
        
      final chaptersMap = await httpFetch( 
        '$databaseUrl/chapters.json?auth=$token&$filters',
      ) as Map<String, dynamic>?;

      chaptersMap?.forEach((chapterId, chapter) { 
        chapters.add(
          Chapter.fromJson({
            'id': chapterId,
            ...chapter,
          }).copyWith(),
        );
      });
      return chapters;
    } catch (error) {
        print(error);
        print('Lỗi');
        return chapters;
    }
  }

  Future<Chapter?> addchapter(Chapter chapter) async {
    try {
      final newchapter = await httpFetch(
        '$databaseUrl/chapters.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          chapter.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      ) as Map<String, dynamic>?;
      print(chapter);
      return chapter.copyWith(
        id: newchapter!['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

    Future<bool> updatechapter(Chapter chapter) async {
    try {
      await httpFetch(
        '$databaseUrl/chapters/${chapter.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(chapter.toJson()),
      );

      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deletechapter(String id) async {
    try {
      await httpFetch(
        '$databaseUrl/chapters/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deletechapterWithProduct(String productId) async {
    try {
      await httpFetch(
        '$databaseUrl/chapters.json?orderBy="productId"&equalTo="$productId"&auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

 
}

