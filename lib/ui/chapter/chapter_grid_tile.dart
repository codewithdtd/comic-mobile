import 'package:flutter/material.dart';

import '../../models/chapter.dart';
import 'chapter_detail.dart';

class ChapterGridTile extends StatelessWidget { 
  const ChapterGridTile(
    this.chapter, {
    super.key,
  });

  final Chapter chapter;

  @override
  Widget build (BuildContext context) {
    return ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              ChapterDetail.routeName,
              arguments: chapter.id,
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, 
            backgroundColor: const Color.fromARGB(255, 31, 181, 91), 
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
            textStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), 
            ),
            elevation: 5, // Độ nâng của nút khi được nhấn
          ),
          child: Text(chapter.title),
    );
  }
}

