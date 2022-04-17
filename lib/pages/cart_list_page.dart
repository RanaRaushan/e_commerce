import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/shopping_cart.dart';

class CartListPage extends StatefulWidget {
  final ShoppingCart cart;

  const CartListPage({required this.cart, Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState()=>  _CartListPageState();

}

class _CartListPageState extends State<CartListPage> {
  static const platform = MethodChannel('camellabs.com/payment');

  Future<void> _checkout() async {
    await platform.invokeMethod('charge', widget.cart.toMap);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    widget.cart.items.forEach((c) {
      items.add(_CartListItemWidget(
        item: c,
        // carts: widget.cart,
      ));
      items.add(const Padding(
        padding: EdgeInsets.only(top: 8.0),
      ));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () => this._checkout(),
              child: Text("Checkout"),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: Color(0xfff0eff4)),
            child: Stack(
              children: <Widget>[
                ListView(
                  padding: EdgeInsets.only(bottom: 64),
                  children: items,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 64,
                  child: _CartFooterWidget(
                    totalPrice: widget.cart.formattedTotalPrice,
                  ),
                ),

              ],
            )));
  }
}

class _CartFooterWidget extends StatelessWidget {
  final String totalPrice;

  const _CartFooterWidget({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color(0XFFF4F4F4),
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: Row(
            children: <Widget>[
              const Text(
                'Total',
                textAlign: TextAlign.left,
                // style: Theme.of(context).textTheme.title,
              ),
              Expanded(
                  child: Text(
                totalPrice,
                textAlign: TextAlign.right,
                // style: Theme.of(context).textTheme.subhead,
              ))
            ],
          )),
        ));
  }
}

class _CartListItemWidget extends StatelessWidget {
  final Item item;
  // final ShoppingCart carts;

  const _CartListItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    var carts = context.watch<ShoppingCart>();
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
                TextButton(onPressed: ()=> carts.remove(item), child: Text("Remove")),
              ]
              )
          ),
          // Text(
          //   "qty: ${item.quantity} | ",
          //   textAlign: TextAlign.right,
          //   // style: Theme.of(context).textTheme.subhead,
          // ),
          // const Padding(
          //   padding: EdgeInsets.only(right: 8.0),
          // ),
          // Text(
          //   "Price: ${item.formattedPrice(item.price*item.quantity)}",
          //   textAlign: TextAlign.right,
          //   // style: Theme.of(context).textTheme.subhead,
          // ),
        ],
      ),
    );
  }
}