
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../screens.dart';

class ChapterDetail extends StatelessWidget { 
  static const routeName = '/chapter-detail';
  
  const ChapterDetail( 
    this.chapter, {
    super.key,
  });

  final Chapter chapter;

  @override
  Widget build (BuildContext context) {
    final chapterManager = context.read<ChapterManager>();
    final chapters = chapterManager.getChaptersByProductId(chapter.productId);
    final currentChapterIndex = chapters.indexWhere((c) => c.id == chapter.id);

    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 255, 214),
      appBar: AppBar(
        title: Text(chapter.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductsOverviewScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapter.image.length,
                  itemBuilder: (context, index) {
                    return Image.network(chapter.image[index]);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ChapterNavbar(
              chapters, currentChapterIndex
            )
          ),
        ],
      ),
    );
  }
}

class ChapterNavbar extends StatelessWidget {
  final List<Chapter> chapters;
  final int currentChapterIndex;

  const ChapterNavbar(
    this.chapters,
    this.currentChapterIndex, {
    super.key
  });

  @override
  Widget build (BuildContext context) {
    final currentChapter = chapters[currentChapterIndex];

    return Container(
      height: 50, // Độ cao của footer
      color: const Color.fromARGB(182, 0, 0, 0), // Màu nền của footer
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_circle_left),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: currentChapterIndex > 0 ? () {
              Navigator.of(context).pushNamed(
                ChapterDetail.routeName,
                arguments: chapters[currentChapterIndex - 1].id,
              );
            } : null,
            iconSize: 30,
          ),
          Text(
            currentChapter.title.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_circle_right_sharp),
           color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: currentChapterIndex < chapters.length - 1
                ? () {
                    Navigator.of(context).pushNamed(
                      ChapterDetail.routeName,
                      arguments: chapters[currentChapterIndex + 1].id,
                    );
                  }
                : null,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
