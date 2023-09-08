import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/Recherche.dart';
import 'package:shop/panier.dart';
import 'AllProduit.dart';
import 'Produit_categories.dart';
import 'new_details.dart';

class Product {
  final String id;
  final String name;
  final String cheminImage; // Utilisez le nom correct de la clé
  final String price;

  Product(this.id, this.name, this.cheminImage, this.price);

}

class Category {
  final String id;
  final String name;

  Category(this.id, this.name);
}


class CartItem {
  final Product product;
  int quantity;
  String? size;
  Color? color;

  CartItem(this.product, this.quantity, {this.size, this.color});
}

class Cart {
  List<CartItem> items = [];

  double get totalPrice =>
      items.fold(0, (total, item) => total + int.parse(item.product.price) * item.quantity);

  void addToCart(Product product, String size, Color color, int quantite) {
    CartItem? cartItem;

    for (var item in items) {
      if (item.product.id == product.id && item.size == size && item.color == color) {
        cartItem = item;
        break;
      }
    }

    if (cartItem != null) {
      cartItem.quantity+=quantite;
    } else {
      items.add(CartItem(product, quantite, size: size, color: color));
    }
  }


  void removeFromCart(CartItem cartItem) {
    items.remove(cartItem);
  }
}


class Boutique extends StatefulWidget {
  const Boutique({super.key});

  @override
  State<Boutique> createState() => _BoutiqueState();
}

class _BoutiqueState extends State<Boutique> {
  final Cart cart = Cart();

  Future<List<Product>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'affiche',
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['prod_id']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['prod_id'], item['nom_prod'], item['chemin_image'], item['prix'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';
    var response = await http.post(Uri.parse(url), body: {
      'click': 'CAT',
    });
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category(item['cat_id'], item['nom_cat'])).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.menu_rounded)),
                Text('Doc\'Shop'),
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(cart: cart,)));
                        }, 
                        icon: Icon(CupertinoIcons.cart_fill),
                    ),
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, SizeTransition5(SecondPage()));
                        },
                        icon: Icon(Icons.search)
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Nouveaute',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),),
                    Text('2020/20/21',style: TextStyle(
                      fontSize: 12
                    ),),
                  ],
                ),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ToutProduits(cart: cart,)));
                    },
                    child: Text('Voir tout',style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54
                ),))
              ],
            ),
          ),
          SizedBox(height: 20,),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  image: DecorationImage(
                      image: AssetImage('images/mugs.png'),
                      fit: BoxFit.cover
                  )
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width/2.3,
                bottom: MediaQuery.of(context).size.height/80,
                child: Container(
                  width: MediaQuery.of(context).size.width/2.2,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Doc\'Shop new',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                      Text('Promotion de 10% sur les tasse',style: TextStyle(
                        fontSize: 11,
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 24),
            child: Row(
              children: [
                Text('Categories',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 50,
            child: FutureBuilder<List<Category>>(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var category = snapshot.data![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProductsPage(cart: cart, category: category),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 10,
                          width: 100,
                          decoration:
                          BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Text(category.name, style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 24),
            child: Row(
              children: [
                Text('Populaires',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(child: FutureBuilder<List<Product>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Aucun produit n\'a ete commandé.'),);
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var product = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => productDetailPage(product: product, cart: cart),
                          //   ),
                          // );
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width/2.6,
                          decoration:
                          BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => productDetailPage(product: product, cart: cart),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 120,
                                        width: MediaQuery.of(context).size.width/3,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    product.cheminImage
                                                ),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(product.name,style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text(product.price+" Fcfa",style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 18,
                                      ),)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),),
          SizedBox(height: 70,),
        ],
      ),
    );
  }
}
