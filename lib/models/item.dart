import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ProductItemModel {

  Item getById(int id) => Item.dummyItems.firstWhere((element) => element.id==id);
  Item getByPosition(int position) {
    return getById(position);
  }
}


class Stock{
  int stockLevel;
  bool get stockStatus => stockLevel==0?false:true;
  Stock(this.stockLevel);
}


class Item {
  String id;
  String name;
  String description;
  int price;
  String imageUrl;
  int quantity;
  int rating;
  Stock stock;
  // String review;

  Item(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.quantity = 1,
      required this.rating,
      required this.stock,
        // requiredthis.review = 0,
      });

  String get formattedAvailability => stock.stockStatus ? "Add to Cart" : "Out of stock";
  String formattedPrice(price) => Item.formatter.format(price);
  Color get availabilityColor => stock.stockStatus ? Colors.grey : Colors.red;

  static final formatter =
      NumberFormat.currency(locale: 'en_US', symbol: "Rs ");

  static List<Item> get dummyItems => [
    Item(
        id: "1",
        name: "iPhone X🅁 (Product RED) 64GB",
        description: 'More magical than ever.',
        price: 12499,
        rating: 4,
        stock: Stock(33),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xr/iphone-xr-red-select-201809?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1551226038669'
    ),
    Item(
        id: "2",
        name: "AirPods with Wireless Charging Case",
        description: 'More magical than ever.',
        price: 2999,
        rating: 3,
        stock: Stock(56),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/M/RX/MRXJ2/MRXJ2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1551489675083'
    ),
    Item(
        id: "3",
        name: "iPhone X🅂 Max (GOLD) 64GB",
        description: 'More magical than ever.',
        price: 18999,
        rating: 2,
        stock: Stock(11),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xs/iphone-xs-max-gold-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795409154'
    ),
    Item(
        id: "4",
        name: "iPhone X🅂 (SILVER) 64GB",
        description: 'More magical than ever.',
        price: 14999,
        rating: 5,
        stock: Stock(4),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xs/iphone-xs-silver-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795411708'
    ),
    Item(
        id: "5",
        name: "iPad Pro (SPACE GRAY) 64GB",
        description: 'More magical than ever.',
        price: 13999,
        rating: 4,
        stock: Stock(13),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/pa/ipad/pro/ipad-pro-11-select-cell-spacegray-201810?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1540591731427'
    ),
    Item(
        id: "6",
        name: "Apple Watch Silver Aluminum (44 mm)",
        description: 'More magical than ever.',
        price: 8999,
        rating: 3,
        stock: Stock(21),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/4/4/44/alu/44-alu-silver-sport-white-s4-1up?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1539190366920'
    ),
    Item(
        id: "7",
        name: "Apple Watch Golden Aluminum (44 mm)",
        description: 'More magical than ever.',
        price: 8999,
        rating: 2,
        stock: Stock(35),
        imageUrl: ''
    ),
    Item(
        id: "8",
        name: "iPhone X🅁 (Product RED) 128GB",
        description: 'More magical than ever.',
        price: 12499,
        rating: 4,
        stock: Stock(33),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xr/iphone-xr-red-select-201809?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1551226038669'
    ),
    Item(
        id: "9",
        name: "AirPods with Wireless Charging Case",
        description: 'More magical than ever.',
        price: 2999,
        rating: 3,
        stock: Stock(56),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/M/RX/MRXJ2/MRXJ2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1551489675083'
    ),
    Item(
        id: "10",
        name: "iPhone X🅂 Max (GOLD) 128GB",
        description: 'More magical than ever.',
        price: 18999,
        rating: 2,
        stock: Stock(11),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xs/iphone-xs-max-gold-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795409154'
    ),
    Item(
        id: "11",
        name: "iPhone X🅂 (SILVER) 128GB",
        description: 'More magical than ever.',
        price: 14999,
        rating: 5,
        stock: Stock(4),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/xs/iphone-xs-silver-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795411708'
    ),
    Item(
        id: "12",
        name: "iPad Pro (SPACE GRAY) 128GB",
        description: 'More magical than ever.',
        price: 13999,
        rating: 4,
        stock: Stock(13),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/i/pa/ipad/pro/ipad-pro-11-select-cell-spacegray-201810?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1540591731427'
    ),
    Item(
        id: "13",
        name: "Apple Watch Silver Aluminum (44 mm)",
        description: 'More magical than ever.',
        price: 8999,
        rating: 3,
        stock: Stock(21),
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/image/AppleInc/aos/published/images/4/4/44/alu/44-alu-silver-sport-white-s4-1up?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1539190366920'
    ),
    Item(
        id: "14",
        name: "Apple Watch Golden Aluminum (44 mm)",
        description: 'More magical than ever.',
        price: 8999,
        rating: 2,
        stock: Stock(35),
        imageUrl: ''
    ),

  ];
}