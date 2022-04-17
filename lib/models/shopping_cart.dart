import 'package:flutter/cupertino.dart';

import 'item.dart';
import 'package:uuid/uuid.dart';

class ShoppingCart extends ChangeNotifier {
  final orderId = const Uuid().v4();

  List<Item> items = [];
  late ProductItemModel _catalog;
  ProductItemModel get catalog => _catalog;

  set catalog(ProductItemModel newCatalog) {
    _catalog = newCatalog;

    notifyListeners();
  }

  bool get isEmpty => items.isEmpty;
  int get numOfItems => items.length;

  int get totalPrice {
    int totalPrice = 0;
    for (var i in items) {
      totalPrice += i.price*i.quantity;
    }
    return totalPrice;
  }

  String get formattedTotalPrice {
    if (isEmpty) {
      return Item.formatter.format(0);
    }

    return Item.formatter.format(totalPrice);
  }

  bool isExists(item) {
    if (items.isEmpty) {
      return false;
    }
    final indexOfItem = items.indexWhere((i) => item.id == i.id);
    return indexOfItem >= 0;
  }

  void add(Item item) {
    debugPrint("${item.quantity} ${item.stock.stockLevel}");
    item.stock.stockLevel--;
    if (items.isEmpty) {
      items.add(item);
      notifyListeners();
      return;
    }
    if (isExists(item)) {
      item.quantity++;
    }
    else {
      items.add(item);
    }
    notifyListeners();
  }

  void remove(Item item) {
    if (items.isEmpty) return;

    final indexOfItem = items.indexWhere((i) {
      if (item.id == i.id){
        item.stock.stockLevel += item.quantity;
        return true;
      }
      return false;
    });
    if (indexOfItem >= 0) {
      items.removeAt(indexOfItem);
    }
    notifyListeners();
  }

  Map<String, dynamic> get toMap {
    final List<Map<String, dynamic>> items = this
        .items
        .map((i) => {
              'id': i.id,
              'name': i.name,
              'description': i.description,
              'price': i.price,
              'stock': i.stock.stockStatus,
              'imageUrl': i.imageUrl
            })
        .toList();

    return {"orderId": orderId, "items": items, "total": totalPrice};
  }
}