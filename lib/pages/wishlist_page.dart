import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/shopping_cart.dart';
import '../models/wishlist_cart.dart';

class FavoritePage extends StatefulWidget {
  static const routeName = '/myFavorite';

  final WishListCart cart;

  const FavoritePage({Key? key, required this.cart}): super(key: key);

  @override
  State<StatefulWidget> createState()=>  _FavoritePageState();

}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    debugPrint("${widget.cart.items}");
    // var wishlist =context.read<WishList>();
    widget.cart.items.forEach((c) {
      items.add(_WishlistItemWidget(
        item: c,
        // carts: widget.cart,
      ));
      items.add(const Padding(
        padding: EdgeInsets.only(top: 8.0),
      ));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('My Favorite'),
        ),
        body: Container(
            decoration: BoxDecoration(color: Color(0xfff0eff4)),
            child: Stack(
              children: <Widget>[
                ListView(
                  padding: EdgeInsets.only(bottom: 64),
                  children: items,
                ),
              ],
            )));
  }
}


class _WishlistItemWidget extends StatelessWidget {
  final Item item;
  // final ShoppingCart carts;

  const _WishlistItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    var carts = context.watch<WishListCart>();
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
              bottom: BorderSide(color: Colors.grey, width: 0.5))),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 64,
            child: AspectRatio(
              aspectRatio: 1,
              child: item.imageUrl.isEmpty? const Text("No Image", textAlign: TextAlign.center,) :Image.network(item.imageUrl),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
          ),
          Expanded(
              child: Text(
            item.name,
            // style:
            //     Theme.of(context).textTheme.title.apply(fontSizeFactor: 0.75),
          )),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Column(children: [
                Row(children: [
                  Text(
                    "qty: ${item.quantity} | ",
                    textAlign: TextAlign.right,
                    // style: Theme.of(context).textTheme.subhead,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                  ),
                  Text(
                    "Price: ${item.formattedPrice(item.price*item.quantity)}",
                    textAlign: TextAlign.right,
                    // style: Theme.of(context).textTheme.subhead,
                  ),
                ],
                ),
                TextButton(onPressed: ()=> carts.remove(item), child: const Text("Remove")),
              ]
              )
          ),
        ],
      ),
    );
  }
}