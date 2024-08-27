import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/user.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class UsersService extends FirebaseService {
  UsersService([AuthToken? authToken]): super(authToken);

  Future<List<User>> fetchUsers({bool filteredByUser = false}) async { 
    final List<User> users = [];

    try {
      final filters =
        filteredByUser? 'orderBy="creatorId"&equalTo="$userId"' : '';
        
      final usersMap = await httpFetch( 
        '$databaseUrl/users.json?auth=$token&$filters',
      ) as Map<String, dynamic>?;

      usersMap?.forEach((userId, user) { 
        users.add(
          User.fromJson({
            'id': userId,
            ...user,
          }).copyWith(),
        );
      });
      return users;
    } catch (error) {
        print(error);
        print('Lỗi');
        return users;
    }
  }

  Future<User?> addUser(User user) async {
    try {
      print(userId);

      final newUser = await httpFetch(
        '$databaseUrl/users.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          user.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      ) as Map<String, dynamic>?;
      return user.copyWith(
        id: newUser!['image'],
      );
    } catch (error) {
      print('Có lỗi xảy ra');
      print(error);
      return null;
    }
  }

    Future<bool> updateUser(User user) async {
    try {
      await httpFetch(
        '$databaseUrl/users/${user.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(user.toJson()
              ..addAll({
              'creatorId': userId,
            }),
          ),
      );

      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }

 
}

