import 'package:flutter/foundation.dart';

import '../../models/user.dart';
import '../../services/users_service.dart';
import '../../models/auth_token.dart';

class UserManager with ChangeNotifier {
  // final List<User> _items = [
  //   User(
  //     id: 'u1',
  //     description: 'I am a profesional writter ',
  //     image: 'https://www.shutterstock.com/shutterstock/photos/2313503433/display_1500/stock-vector-young-man-anime-style-character-vector-illustration-design-anime-boy-2313503433.jpg',
  //     name: 'Cute Boy',
  //   ),
  // ];
  List<User> _items = [];
  List<User> _itemsAll = [];

  final UsersService _usersService;

  int get itemCount {
    return _items.length;
  }

  List<User> get items {
    return [..._items];
  }

  List<User> get itemsAll {
    return [..._items];
  }

  User? findByCreatorId(String id) {
    try {
      return _itemsAll.firstWhere((item) => item.creatorId == id);
    } catch (error) {
      return null;
    }
  }

  User? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  User? findByIdScreen(String id) {
    try {
      return _itemsAll.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  UserManager([AuthToken? authToken])
      : _usersService = UsersService(authToken);

  set authToken(AuthToken? authToken) {
    _usersService.authToken = authToken;
  }

  Future<void> fetchUsers() async {
    _itemsAll = await _usersService.fetchUsers();
    notifyListeners();
  }

  Future<void> fetchUserUsers() async {
    _items = await _usersService.fetchUsers(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    print('user manager');
    final newUser = await _usersService.addUser(user);
    if(newUser != null) {
      _items.add(newUser);
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    final index =_items.indexWhere((item)=>item.id== user.id);
    if(index >=0){
      if(await _usersService.updateUser(user)) {
        _items[index]=user;
        notifyListeners();
      }
    }
  }

  // void deleteUser(String id){
  //   final index = _items.indexWhere((item)=> item.id== id);
  //   _items.removeAt(index);
  //   notifyListeners();
  // }

}