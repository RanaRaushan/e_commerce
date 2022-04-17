import 'package:e_commerce/models/wishlist_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../pages/wishlist_page.dart';

class MyDrawer extends StatelessWidget {

  final Color drawerTextColor = Colors.white;
  final Color drawerBgColor = Colors.blue.shade400;
  User? user;
  MyDrawer({this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBgColor,
      child: ListView(
      children: [
        DrawerHeader(child: ClipRect(
          child: Stack(
          children: [
            Text("Welcome, ${user?.name??""}",style: TextStyle(color: drawerTextColor,fontSize: 25)),
          ],
          )
        )),
        ListTile(
          textColor: drawerTextColor,
          iconColor: drawerTextColor,
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            // TODO
          },
        ),
        ListTile(
          textColor: drawerTextColor,
          iconColor: drawerTextColor,
          leading: const Icon(Icons.favorite),
          title: const Text('My Wishlist'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                Consumer<WishListCart>(
                    builder: (context, cart, child) => FavoritePage( cart: cart))
              ,));
          },
        ),
        ListTile(
          textColor: drawerTextColor,
          iconColor: drawerTextColor,
          leading: const Icon(Icons.person),
          title: const Text('My Account'),
          onTap: () {
            // TODO
          },
        ),
        ListTile(
          textColor: drawerTextColor,
          iconColor: drawerTextColor,
          leading: const Icon(Icons.settings),
          title: const Text('Setting'),
          onTap: () {
            // TODO
          },
        ),
      ],)
    );
  }
}