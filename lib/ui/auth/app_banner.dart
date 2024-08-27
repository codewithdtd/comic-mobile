// import 'dart:math';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 60.0,
      ),
      // transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
      // decoration: const BoxDecoration(
      //   // borderRadius: BorderRadius.circular(20),
      //   color: Color.fromARGB(255, 0, 182, 64),
      //   boxShadow: [
      //     BoxShadow(
      //       blurRadius: 8,
      //       color: Colors.black26,
      //       offset: Offset(0, 2),
      //     )
      //   ],
      // ),
      child: const Row(
        children: [
          Text(
            'DD Manga',
            style: TextStyle(
              // color: Theme.of(context).textTheme.titleLarge?.color,
              color: Color.fromARGB(255, 27, 168, 72),
              fontSize: 50,
              fontFamily: 'Anton',
              fontWeight: FontWeight.normal,
            ),
          ),
          Icon(Icons.book, size: 50, color: Color.fromARGB(255, 27, 168, 72), ),
        ],
      ),
    );
  }
}
