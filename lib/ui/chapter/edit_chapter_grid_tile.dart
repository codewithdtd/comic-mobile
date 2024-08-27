import 'package:ct484_project/ui/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';


class EditChapterGridTile extends StatelessWidget { 
  const EditChapterGridTile(
    {
    this.productId,
    this.chapter,
    Key? key,
  }) : super(key: key);

  final String? productId;
  final Chapter? chapter;

  @override
  Widget build (BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Màu sắc của đường viền
            width: 2.0, // Độ dày của đường viền
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chapter!.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              EditUserButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditChapterScreen.routeName,
                  // arguments: chapter.id,
                  arguments: {
                    'chapterId': chapter!.id,
                    'productId': productId,
                  },
                );
              },
            ),
            DeleteUserButton(
              onPressed: () {
                context.read<ChapterManager>().deleteChapter(chapter!.id!);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chapter deleted',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeleteUserButton extends StatelessWidget {
  const DeleteUserButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error, 
    );
  }
}

class EditUserButton extends StatelessWidget {
  const EditUserButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary, 
    );
  }
}