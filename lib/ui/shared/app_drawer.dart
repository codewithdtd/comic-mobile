import 'package:ct484_project/ui/screens.dart';
import 'package:flutter/material.dart';

// import '../orders/orders_screen.dart';
import '../../models/user.dart';
import '../products/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';

class AppDrawer extends StatelessWidget { 
  const AppDrawer({super.key});

  @override
  Widget build (BuildContext context) {
    final userManager = context.read<UserManager>();
    final List<User> users = userManager.items;

    User user = users.isNotEmpty ? users[0] : User(
      id: null,
      creatorId: '',
      title: 'No name',
      description: 'Nothing',
      imageAvatar: 'https://as1.ftcdn.net/v2/jpg/02/59/39/46/1000_F_259394679_GGA8JJAEkukYJL9XXFH2JoC3nMguBPNH.jpg',
      imageBackground: 'https://as1.ftcdn.net/v2/jpg/05/13/78/06/1000_F_513780633_mt5NFgJpsvhY5DeHE8gfJQXxlUgnfbJ9.jpg' 
    );

    return Drawer(
      child: Column(
      children: <Widget>[
        // AppBar(
          // title:
        Container(
          padding: const EdgeInsets.all(14.0),
          color: Color.fromARGB(255, 9, 153, 59),
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40), // Đặt bán kính của hình tròn
                    child: Image.network(
                      user.imageAvatar,
                      width: 80, // Đặt kích thước ảnh
                      height: 80, // Đặt kích thước ảnh
                      fit: BoxFit.cover, // Đảm bảo ảnh được lấp đầy không gian được cắt bởi ClipRRect
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.title, 
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis, // Tránh tràn ra ngoài khi văn bản quá dài
                      maxLines: 1, 
                      textAlign: TextAlign.left,// Chỉ hiển thị một dòng
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        user.description, 
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis, // Tránh tràn ra ngoài khi văn bản quá dài
                        maxLines: 1, 
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ]
            ),
          ), 
          // automaticallyImplyLeading: false,
        // ),
        ListTile(
          leading: const Icon (Icons.book),
          title: const Text('Đọc truyện'),
          onTap: () {
            Navigator.of (context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_document),
          title: const Text('Truyện của bạn'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Trang cá nhân'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserDetailScreen.routeName, 
                arguments: user.id);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
                context.read<AuthManager>().logout();
            },
          )
        ],
      ),
    );
  }
}