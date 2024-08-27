
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../screens.dart';

class ProductDetailScreen extends StatelessWidget { 
  static const routeName = '/product-detail';
  
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;
  @override
  Widget build (BuildContext context) {
    final chapters = context.read<ChapterManager>().getChaptersByProductId(product.id);

    final creator = context.read<UserManager>().findByCreatorId(product.creatorId);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 255, 214),
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(     
        child: Column(
          children: <Widget>[
            const SizedBox (height: 20),
            SizedBox(
              height: 350,
              width: 250,
              child: Image.network (product.imageUrl, fit: BoxFit.cover), 
            ),
            const SizedBox (height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 30, // Kích thước chữ lớn
                  fontWeight: FontWeight.bold, // Kiểu bold
                  color: Colors.green, // Màu xanh lá
                ),
              ),
            ),
            
            Text('Tác giả: ${product.author}', style: TextStyle(fontWeight: FontWeight.w600),),
            if(creator != null) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Người đăng: ', style: TextStyle(fontWeight: FontWeight.w600),),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      UserScreen.routeName,
                      arguments: creator.id,
                    );
                  },
                  child: Text(creator.title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),)),
              ],
            ),
            
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: product.isFavoriteListenable,
                  builder: (ctx, isFavorite, child) {
                    return ElevatedButton(
                      onPressed: () {
                        ctx.read<ProductsManager>().toggleFavoriteStatus(product);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Giảm border radius xuống còn 10
                        ),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 41, 41), // Màu sắc của viền
                          width: 2.0, // Độ dày của viền
                        ),
                        foregroundColor: const Color.fromARGB(255, 255, 36, 36), 
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                        minimumSize: const Size(50, 50),
                      ),
                      child: Icon(product.isFavorite? Icons.favorite : Icons. favorite_border, size: 25,)
                    );
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ChapterDetail.routeName,
                      arguments: chapters[0].id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Giảm border radius xuống còn 10
                    ),
                    foregroundColor: Colors.white, 
                    backgroundColor: const Color.fromARGB(255, 3, 150, 49), 
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'ĐỌC NGAY',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox (height: 10),
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Text(
                product.description
              ),
            ),
            const SizedBox (height: 10),
            const Text('Danh sách chương',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChapterGrid(product),
            ),
          ],
        ),
      ),
    );
  }
}