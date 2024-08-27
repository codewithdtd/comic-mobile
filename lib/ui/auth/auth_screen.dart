import 'package:flutter/material.dart';

import 'auth_card.dart';
import 'app_banner.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/564x/bf/11/04/bf11044b5a36b41a9ae8ba0d434a1a6d.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     const Color.fromARGB(255, 99, 239, 255).withOpacity(0.5),
                //     const Color.fromARGB(255, 69, 255, 112).withOpacity(0.9),
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   stops: const [0, 1],
                // ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                      child: AppBanner(),
                    ),
                    Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
