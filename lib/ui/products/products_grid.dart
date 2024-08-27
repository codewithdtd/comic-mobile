import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_grid_tile.dart';
import 'products_manager.dart';
import '../../models/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid (this.showFavorites, {super.key});

  @override
  Widget build (BuildContext context) {
    // final productsManager = ProductsManager();
    // final products =
    //   showFavorites ? productsManager.favoriteItems : productsManager.items;
    

    return FutureBuilder(
      future: context.read<ProductsManager>().fetchProducts(),
      builder: (context, snapshot) {
        final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => showFavorites
          ? productsManager.favoriteItems
          : productsManager.items);
        
        return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ProductGridTile (products[i]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
              crossAxisCount: 1,
              childAspectRatio: 2/1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
      }
    );
  }
}