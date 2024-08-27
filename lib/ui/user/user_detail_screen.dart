
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/user.dart';
import '../screens.dart';
import '../shared/app_drawer.dart';
import 'edit_user_screen.dart';

class UserDetailScreen extends StatelessWidget { 
  static const routeName = '/user-detail';
  
  UserDetailScreen(
    User? user, {
    super.key,
  }) {
    if (user == null) {
      this.user = User(
        id: null,
        title: 'No name',
        creatorId: '',
        description: 'Nothing',
        imageAvatar: 'https://as1.ftcdn.net/v2/jpg/02/59/39/46/1000_F_259394679_GGA8JJAEkukYJL9XXFH2JoC3nMguBPNH.jpg',
        imageBackground: 'https://d2gg9evh47fn9z.cloudfront.net/1600px_COLOURBOX42714331.jpg'
      );
    } else {
        this.user = user;
    }
  }

  final double coverHeight = 200;
  final double profileHeight = 70;

  late final User user;

  @override
  Widget build (BuildContext context) {
    // final products = context.read<ProductsManager>().items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
            title: const Text('Trang cá nhân'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditUserScreen.routeName,
                    arguments: user.id,
                  );
                }, 
                icon: const Icon(Icons.edit),
              ),
            ],
        ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Future.wait([
          context.read<UserManager>().fetchUserUsers(),
          context.read<ProductsManager>().fetchUserProducts(),
        ]),
        builder: (context, snapshot) {
          final products = context.read<ProductsManager>().items;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return RefreshIndicator(
            child: ListView(
                // padding: EdgeInsets.zero,
                children: <Widget>[
                  buildTop(),
                  buildContent(products),
                ],
              ), 
            onRefresh: ()=>context.read<UserManager>().fetchUserUsers(),
          );
        }
      ),
    );
  }

  Widget buildTop() {
    return Consumer<UserManager>(
      builder: (context, productsManager, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: profileHeight),
              child: buildCoverImage()
            ),
            Positioned(
              top: coverHeight - profileHeight,
              child: buildProfileImage()
            ),
          ],
        );
      }
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: user.imageBackground.isEmpty 
    ? Image.network(
      'https://d2gg9evh47fn9z.cloudfront.net/1600px_COLOURBOX42714331.jpg',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ) : Image.network(
      user.imageBackground,
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    )
  );

  Widget buildProfileImage() => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white,
        width: 4.0,
      ),
    ),
    child: CircleAvatar(
      radius: profileHeight,
      backgroundColor: Colors.grey.shade700,
      backgroundImage: user.imageAvatar.isNotEmpty ? NetworkImage(user.imageAvatar) : const NetworkImage('https://as1.ftcdn.net/v2/jpg/02/59/39/46/1000_F_259394679_GGA8JJAEkukYJL9XXFH2JoC3nMguBPNH.jpg'),
    ),
  );

  Widget buildContent(List<Product> products) => Consumer<ProductsManager>(
    builder: (context, productsManager, child) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.title,
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 6, 108, 10),
              ),
            ),
            Text(
              user.description,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Truyện của tôi:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            ...List.generate(products.length, (index) {
              // Nếu index không phải là phần tử cuối cùng, thêm SizedBox sau UserProduct
              if (index < products.length - 1) {
                return Column(
                  children: [
                    UserProduct(products[index]),
                    const SizedBox(height: 10), // Khoảng cách giữa các UserProduct
                  ],
                );
              } else {
                // Nếu là phần tử cuối cùng, không cần thêm SizedBox
                return UserProduct(products[index]);
              }
            }),
          ],
        ),
      );
    }
  );

 
}

class UserProduct extends StatelessWidget { 
    const UserProduct(
      this.product, {
      super.key,
    });

    final Product product;

    @override
    Widget build (BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 197, 255, 200),
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10), 
                child: SizedBox(
                  height: 100, // Chiều cao mong muốn của hình ảnh
                  width: 100, // Chiều rộng của hình ảnh
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                )
              ),  
            ],
          ),
      ),
    );
  }
}