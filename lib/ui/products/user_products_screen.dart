import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens.dart';
import '../shared/app_drawer.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truyện của bạn'),
        actions: <Widget>[
          // Bắt sự kiện cho nút add
          AddUserProductButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      // body: const UserProductList(),
      body: FutureBuilder(
        future: context.read<ProductsManager>().fetchUserProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            child: const UserProductList(), 
            onRefresh: () => 
              context.read<ProductsManager>().fetchUserProducts(),
          );
        },
      )
    );
  }
}

class UserProductList extends StatelessWidget {
  
  const UserProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final productManager = context.watch<ProductsManager>();


    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              // const SizedBox(height: 10,),
              UserProductListTile(
                productManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}

class AddUserProductButton extends StatelessWidget {
  const AddUserProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: onPressed, 
    );
  }
}