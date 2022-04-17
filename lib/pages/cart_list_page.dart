import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/models/item.dart';
import 'package:e_commerce/models/shopping_cart.dart';

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

    for (var c in widget.cart.items) {
      items.add(_CartListItemWidget(
        item: c,

      ));
      items.add(const Padding(
        padding: EdgeInsets.only(top: 8.0),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () => this._checkout(),
              child: const Text("Checkout"),
            )
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(color: Color(0xfff0eff4)),
            child: Stack(
              children: <Widget>[
                ListView(
                  padding: const EdgeInsets.only(bottom: 64),
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
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Row(
            children: <Widget>[
              const Text(
                'Total',
                textAlign: TextAlign.left,

              ),
              Expanded(
                  child: Text(
                totalPrice,
                textAlign: TextAlign.right,

              ))
            ],
          )),
        ));
  }
}

class _CartListItemWidget extends StatelessWidget {
  final Item item;


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

                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                  ),
                  Text(
                    "Price: ${item.formattedPrice(item.price*item.quantity)}",
                    textAlign: TextAlign.right,

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