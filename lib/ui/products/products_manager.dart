import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../models/auth_token.dart';
import '../../services/products_service.dart';


class ProductsManager with ChangeNotifier {
  // final List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Your name',
  //     // price: 22000,
  //     author: 'Cute Boy',
  //     description: '',
  //     imageUrl:
  //         'https://kenh14cdn.com/thumb_w/660/2017/2-1495831147934.jpg',
  //     isFavorite: true,
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Fairy Tail',
  //     // price: 22000,
  //     author: 'Cute Boy',
  //     description: 'A nice pair of trousers.',
  //     imageUrl:
  //         'https://cdn-www.bluestacks.com/bs-images/GameTile_Fairy_Tail.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Suzume no Tojimari',
  //     // price: 22000,
  //     author: 'Cute Boy',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/vi/thumb/5/51/Suzume_no_Tojimari.tiff/lossy-page1-1200px-Suzume_no_Tojimari.tiff.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'Kimetsu no yaiba',
  //     // price: 22000,
  //     author: 'Cute Boy',
  //     description: 'Prepare any meal you want.',
  //     imageUrl:
  //         'https://awsimages.detik.net.id/community/media/visual/2024/02/29/demon-slayer-kimetsu-no-yaiba-to-the-hashira-training.jpeg',
  //     isFavorite: true,
  //   ),
  // ];

  List<Product> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> itemsScreen(String creatorId) {
    return _items.where((item) => item.creatorId == creatorId).toList();
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  final ProductsService _productsService;

  ProductsManager([AuthToken? authToken])
      : _productsService = ProductsService(authToken);

  set authToken(AuthToken? authToken) {
    _productsService.authToken = authToken;
  }

  Future<void> fetchProducts() async {
    _items = await _productsService.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    _items = await _productsService.fetchProducts(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if(newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if(index >= 0) {
      if (await _productsService.updateProduct(product)) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Product? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _productsService.deleteProduct(id)) {
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(Product product) async {
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;

    if(!await _productsService.saveFavoriteStatus(product)) {
      product.isFavorite = savedStatus;
    }
  }

}