import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens.dart';
import '../shared/app_drawer.dart';
import 'products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen ({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}
class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // var _showOnlyFavorites = false;
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;
  late Future<void> _fetchUser;
  late Future<void> _fetchUserAll;


  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
    _fetchUser = context.read<UserManager>().fetchUserUsers();
    _fetchUserAll = context.read<UserManager>().fetchUsers();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text('DD Manga'),
        actions: <Widget>[
          ProductFilterMenu(
            onFilterSelected: (filter) {
              setState(() {
                if (filter == FilterOptions.favorites) {
                  _showOnlyFavorites.value = true;
                } else {
                  _showOnlyFavorites.value = false;
                }
              });
            },
          ),
          UserButton(
            onPressed: () {
              final user = context.read<UserManager>().items;
              Navigator.of(context).pushNamed(
                UserDetailScreen.routeName,
                arguments: user.isNotEmpty ? user[0].id : null,
              );
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      // body: ProductsGrid (_showOnlyFavorites),
      body: FutureBuilder(
        future: Future.wait([
          _fetchProducts,
          _fetchUser,
          _fetchUserAll,
        ]) ,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
              valueListenable: _showOnlyFavorites, 
              builder: (context, onlyFavorites, child) {
                return ProductsGrid(onlyFavorites);
              });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
  class ProductFilterMenu extends StatelessWidget {
    const ProductFilterMenu ({super.key, this.onFilterSelected});

    final void Function(FilterOptions selectedValue)? onFilterSelected;

    @override
    Widget build(BuildContext context) {
      return PopupMenuButton(
        onSelected: onFilterSelected,
        icon: const Icon(
          Icons.more_vert,
    ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites, 
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}
  class UserButton extends StatelessWidget { 
    const UserButton({super.key, this.onPressed});

    final void Function()? onPressed;

    @override
    Widget build(BuildContext context) {
      return IconButton(
        icon: const Icon(
          Icons.person_sharp
          , 
        ),
        style: ButtonStyle(iconSize: MaterialStateProperty.all(30)),
        onPressed: onPressed,
      );
    }
  }