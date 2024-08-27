import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/products/products_manager.dart';

import '../../models/product.dart';
import 'product_detail_screen.dart';

class ProductGridTile extends StatelessWidget { 
  const ProductGridTile(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build (BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), 
      child: GridTile(
        child: GestureDetector(
          // behavior: HitTestBehavior.translucent,
          onTap: () {
            // print('Go to product detail screen');
            // Chuyển đến trang ProductDetailScreen
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Row(
            children: [
              Image.network(
                product.imageUrl,
                width: 140,          
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  color: Color.fromARGB(255, 255, 233, 215),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 25, 
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          product.description, 
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                          ),
                      ),
                      ProductGridFooter(
                        product: product, 
                        onFavoritePressed: () {
                          context.read<ProductsManager>().toggleFavoriteStatus(product);
                        },
                        onAddToCartPressed: () {
                          print('Add item to cart');
                        },)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProductGridFooter extends StatelessWidget { 
  const ProductGridFooter({
    super.key,
    required this.product, 
    this.onFavoritePressed, 
    this.onAddToCartPressed,
  });

  final Product product;
  final void Function()? onFavoritePressed; 
  final void Function()? onAddToCartPressed;

  @override
  Widget build (BuildContext context) {
    return GridTileBar(
      // backgroundColor: Colors.black87, 
      // Dùng ValueListenableBuilder để lắng nghe
      // sự thay đổi giá trị của product.isFavorite
      leading: ValueListenableBuilder<bool>(
        valueListenable: product.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onFavoritePressed,
          );
        },
      ),
      title: const Text(''),

      trailing: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Giảm border radius xuống còn 10
          ),
          foregroundColor: Colors.white, 
          backgroundColor: const Color.fromARGB(255, 3, 150, 49), 
        ),
        child: const Text(
          'Đọc',
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
    );
  }
}