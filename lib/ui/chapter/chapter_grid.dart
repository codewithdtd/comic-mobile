import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import 'chapter_grid_tile.dart';
import 'chapter_manager.dart';

class ChapterGrid extends StatelessWidget {

  const ChapterGrid (
    this.product,
    {super.key});
  final Product product;
  @override
  Widget build (BuildContext context) {
    // final chapters = context.select<ChapterManager, List<Chapter>>(
    //   (chapterManager) => chapterManager.getChaptersByProductId(product.id)
    // );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: chapters.map((chapter) => ChapterGridTile(chapter)).toList(),
    // );
    return FutureBuilder<void>(
      future: context.read<ChapterManager>().fetchChapters(), // Fetch chapters when the widget is built
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for data
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle errors
          return Text('Error: ${snapshot.error}');
        } else {
          // Once data is loaded, retrieve chapters and build UI
          final chapters = context.read<ChapterManager>().getChaptersByProductId(product.id);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                chapters.map((chapter) => ChapterGridTile(chapter)).toList(),
          );
        }
      },
    );
  }
}

