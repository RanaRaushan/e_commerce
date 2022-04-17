import 'package:flutter/cupertino.dart';

import 'item.dart';

class WishListCart extends ChangeNotifier {

  List<Item> items = [];

  late ProductItemModel _catalog;
  ProductItemModel get catalog => _catalog;

  set catalog(ProductItemModel newCatalog) {
    _catalog = newCatalog;

    notifyListeners();
  }

  bool get isEmpty => items.isEmpty;
  int get numOfItems => items.length;


  bool isExists(item) {
    debugPrint("$items");
    if (items.isEmpty) {
      return false;
    }
    final indexOfItem = items.indexWhere((i) => item.id == i.id);
    return indexOfItem >= 0;
  }

  void add(Item item) {
    if (items.isEmpty) {
      items.add(item);
      debugPrint("add $items");
      return;
    }

    if (!isExists(item)) {
      items.add(item);
    }
    notifyListeners();
  }

  void remove(Item item) {
    debugPrint("$item $items");
    if (items.isEmpty) return;

    final indexOfItem = items.indexWhere((i) {
      if (item.id == i.id){
        return true;
      }
      return false;
    });
    if (indexOfItem >= 0) {
      items.removeAt(indexOfItem);
    }
    notifyListeners();
  }
}