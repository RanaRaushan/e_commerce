
import 'package:e_commerce/models/wishlist_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'models/item.dart';
import 'models/shopping_cart.dart';

void main() {
  setPathUrlStrategy();
  runApp(
      MultiProvider(
        providers: [
          Provider(create: (context) => ProductItemModel()),
          ChangeNotifierProxyProvider<ProductItemModel, ShoppingCart>(
            create: (context) => ShoppingCart(),
            update: (context, item, cart) {
              if (cart == null) throw ArgumentError.notNull('cart');
              cart.catalog = item;
              return cart;
            },
          ),
          ChangeNotifierProxyProvider<ProductItemModel, WishListCart>(
            create: (context) => WishListCart(),
            update: (context, item, cart) {
              if (cart == null) throw ArgumentError.notNull('Wishlist');
              cart.catalog = item;
              return cart;
            },
          ),
        ],
        child: const MyApp(),
      )
  );
}

