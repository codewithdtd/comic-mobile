// import 'package:ct484_project/ui/chapter/chapter_detail.dart';
// import 'package:ct484_project/ui/chapter/chapter_grid.dart';
// import 'package:ct484_project/ui/chapter/chapter_manager.dart';
// import 'package:ct484_project/ui/user/user_detail_screen.dart';
// import 'package:ct484_project/ui/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'ui/chapter/chapter_manager.dart';
// import 'ui/products/product_detail_screen.dart';
// import 'ui/products/products_manager.dart';
// import 'ui/products/products_overview_screen.dart';
// import 'ui/products/user_products_screen.dart';

import 'ui/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'ui/user/user_detail_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 9, 255, 87),
      secondary: const Color.fromARGB(255, 255, 60, 34),
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themeData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 4,
      shadowColor: colorScheme.shadow,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager()),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => ChapterManager(),
        // ),
        ChangeNotifierProxyProvider<AuthManager, ChapterManager>(
          create: (ctx) => ChapterManager(),
          update: (ctx, authManager, chapterManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            chapterManager!.authToken = authManager.authToken;
            return chapterManager;
          },
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => UserManager(),
        // ),
        ChangeNotifierProxyProvider<AuthManager, UserManager>(
          create: (ctx) => UserManager(),
          update: (ctx, authManager, userManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            userManager!.authToken = authManager.authToken;
            return userManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return MaterialApp(
            title: 'DocTruyen',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: authManager.isAuth
              ? const SafeArea(child: ProductsOverviewScreen())
              : FutureBuilder(
                future: authManager.tryAutoLogin(), 
                builder: (ctx, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const SafeArea(child: SplashScreen())
                      : const SafeArea(child: AuthScreen());
                }
              ),
            routes: {
              // ChapterDetail.routeName: (ctx) => const SafeArea(
              //   child: ChapterDetail(),
              // ),
              UserProductsScreen.routeName: (ctx) => const SafeArea(
                child: UserProductsScreen(),
              ),
              // UserDetailScreen.routeName: (ctx) =>  SafeArea(
              //   child: UserDetailScreen(ctx.watch<UserManager>().items[0]),
              // ),
              
            },
            // onGenerateRoute sẽ được gọi khi không tìm thấy route yêu cầu
            // trong thuộc tính routes ở trên. Thường dùng để truyền tham số
            // hoặc tùy biến hiệu ứng chuyển trang.
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                // return MaterialPageRoute(
                //   settings: settings,
                //   builder: (ctx) {
                //     // final productId = settings.arguments as String;
                //     return SlideTransition(
                //       position: Tween<Offset>(
                //         begin: const Offset(1.0, 0.0), // Bắt đầu từ phải
                //         end: Offset.zero, // Đến vị trí mặc định
                //       ).animate(ModalRoute.of(ctx)!.animation!),
                //       child: SafeArea(
                //         child: ProductDetailScreen(
                //           ctx.read<ProductsManager>().findById(productId)!,
                //         ),
                //       ),
                //     );
                //   },
                // );
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (ctx, animation, secondaryAnimation) {
                    // final productId = settings.arguments as String;
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0), // Bắt đầu từ phải
                        end: Offset.zero, // Đến vị trí mặc định
                      ).animate(animation),
                      child: SafeArea(
                        child: ProductDetailScreen(
                          ctx.read<ProductsManager>().findById(productId)!,
                        ),
                      ),
                    );
                  },
                );
              }
              if (settings.name == ChapterDetail.routeName) {
                final chapterId = settings.arguments as String;
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (ctx, animation, secondaryAnimation) {
                    // final productId = settings.arguments as String;
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0), // Bắt đầu từ phải
                        end: Offset.zero, // Đến vị trí mặc định
                      ).animate(animation),
                      child: SafeArea(
                        child: ChapterDetail(
                          ctx.read<ChapterManager>().findById(chapterId)!,
                        ),
                      ),
                    );
                  },
                );
              }
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: EditProductScreen(
                        productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                      ),
                    );
                  },
                );
              }
              if (settings.name == EditUserScreen.routeName) {
                final userId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: EditUserScreen(
                        userId != null
                        ? ctx.read<UserManager>().findById(userId)
                        : null,
                      ),
                    );
                  },
                );
              }
              if (settings.name == EditChapterScreen.routeName) {
                // final chapterId = settings.arguments as String?;
          
                final arguments = settings.arguments as Map<String, dynamic>?;
          
                // Lấy productId từ arguments
                final productId = arguments?['productId'] as String?;
                final chapterId = arguments?['chapterId'] as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: EditChapterScreen(
                        productId!,
                        chapterId != null
                        ? ctx.read<ChapterManager>().findById(chapterId)
                        : null,
                      ),
                    );
                  },
                );
              }
              if (settings.name == EditChapterDetailScreen.routeName) {
                final chapterId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: EditChapterDetailScreen(
                        chapterId != null
                        ? ctx.watch<ChapterManager>().findById(chapterId)
                        : null,
                      ),
                    );
                  },
                );
              }
              if (settings.name == UserDetailScreen.routeName) {
                final userId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: UserDetailScreen(
                        userId != null ?
                        ctx.read<UserManager>().findById(userId) 
                        : null
                      ),
                    );
                  },
                );
              }
              if (settings.name == UserScreen.routeName) {
                final userId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: UserScreen(
                        userId != null ?
                        ctx.read<UserManager>().findByIdScreen(userId) 
                        : null
                      ),
                    );
                  },
                );
              }
              return null;
            },
          );
        }
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

