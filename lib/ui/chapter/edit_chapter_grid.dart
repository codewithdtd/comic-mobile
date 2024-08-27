import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../models/product.dart';

import 'chapter_manager.dart';
import 'edit_chapter_grid_tile.dart';

class EditChapterGrid extends StatelessWidget {

  const EditChapterGrid (
    this.product,
    {super.key});
  final Product product;
  @override
  Widget build (BuildContext context) {
    // final chapterManager = ChapterManager();
    // final chapters = chapterManager.getChaptersByProductId(product.id);

    // final chapters = context.select<ChapterManager, List<Chapter>>(
    //   (chapterManager) => chapterManager.getChaptersByProductId(product.id)
    // );
    final chapters = context.watch<ChapterManager>().getChaptersByProductId(product.id);

    // return ListView.builder(
    //   itemCount: chapter.length,
    //   itemBuilder: (ctx, i) => EditChapterGridTile (chapter[i]),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: chapters.map((chapter) => EditChapterGridTile(chapter: chapter, productId: product.id)).toList(),
    );
  }
}

