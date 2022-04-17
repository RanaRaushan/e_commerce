import 'package:e_commerce/pages/login_page.dart';
import 'package:e_commerce/pages/product_listing_page.dart';
import 'package:e_commerce/pages/signup_page.dart';
import 'package:e_commerce/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/wishlist_cart.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackBarKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        SignupPage.routeName: (context) => const SignupPage(),
        ProductListingPage.routeName: (context) => const ProductListingPage(),
        // FavoritePage.routeName: (context) => FavoritePage(),
      },
    );
  }
}
