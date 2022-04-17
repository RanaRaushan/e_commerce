import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/models/item.dart';
import 'package:e_commerce/models/shopping_cart.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/models/wishlist_cart.dart';
import 'package:e_commerce/widget/drawer.dart';
import 'cart_list_page.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class ProductListingPage extends StatefulWidget {
  static const routeName = '/productListingPage';

  const ProductListingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _ProductListingState();

}

class _ProductListingState extends State<ProductListingPage> {

  final List<Item> items = Item.dummyItems;

  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)?.settings.arguments as User?;
    debugPrint("user is :$user");
    final columnCount =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;

    final width = MediaQuery.of(context).size.width / columnCount;
    const height = 440;
    var cart = context.read<ShoppingCart>();
    var wishListCart = context.read<WishListCart>();

    List<Widget> items = [];
    for (var x = 0; x < this.items.length; x++) {
      final item = this.items[x];

      items.add(_ItemListView(
        item: item,
        isInCart: cart.isExists(item),
        onTap: (item) {
          snackBarKey.currentState?.hideCurrentSnackBar();

          cart.add(item);
          snackBarKey.currentState?.showSnackBar(const SnackBar(
            content: Text('Item is added to cart!'),
          ));

          setState(() {});
        },
        isFavorite: wishListCart.isExists(item),
        onFavTap: (item){

          if (wishListCart.isExists(item)) {
            wishListCart.remove(item);
            snackBarKey.currentState?.showSnackBar(const SnackBar(
              content: Text('Item is removed from favorite!'),
            ));
          } else {
            wishListCart.add(item);
            snackBarKey.currentState?.showSnackBar(const SnackBar(
              content: Text('Item is added to favorite!'),
            ));
          }
          setState(() {});
        }
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("E-Commerce Store"),
        ),
        drawer: MyDrawer(user: user,),
        body: GridView.count(
          childAspectRatio: width / height,
          scrollDirection: Axis.vertical,
          crossAxisCount: columnCount,
          children: items,
        ),
        floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Consumer<ShoppingCart>(
                              builder: (context, cart, child) => CartListPage( cart: cart))
                  ));
                },
                icon: const Icon(Icons.shopping_cart),
                label: Text("${cart.numOfItems}"),
              ));
  }
}

class _ItemListView extends StatelessWidget {
  final Item item;
  final bool isInCart;
  dynamic onTap;
  final bool isFavorite;
  dynamic onFavTap;

  _ItemListView({required this.item, required this.isInCart, this.onTap, this.onFavTap, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    Border border =const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
          right: BorderSide(color: Colors.grey, width: 0.5));

    List<Widget> _iconList = [];
    for(int i=0;i<5;i++){
      if(item.rating>i){
      _iconList.add(Icon(Icons.star, color: Colors.green[500]));
      }
      else{
        _iconList.add(const Icon(Icons.star, color: Colors.black));
      }
    }
    _buildStar ()=>Row(
      mainAxisSize: MainAxisSize.min,
      children: _iconList,
    );
    card ()=> Container(
      decoration: BoxDecoration(border: border),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            SizedBox(
              child: AspectRatio(
                aspectRatio: 1,
                child: item.imageUrl.isEmpty? const Text("No Image", textAlign: TextAlign.center,) :Image.network(item.imageUrl),
              ),
              height: 250,
            ),
            _buildStar(),
            Text("Stock left:${item.stock.stockLevel}"),
            const Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text(item.name,
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text(item.formattedPrice(item.price),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            ElevatedButton(
              onPressed: !item.stock.stockStatus?null :()=>onTap(item), child: Text(item.formattedAvailability),
            ),
          ],
        )
        ),
        Align(
          alignment: Alignment.topRight,
          child:IconButton(onPressed: ()=> onFavTap(item), icon: isFavorite?const Icon(Icons.favorite):const Icon(Icons.favorite_border)),
        )
      ])
    );
    return card();
  }
}