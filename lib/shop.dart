import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Produit_categories.dart';
import 'details_produits.dart';


class Product {
  final int id;
  final String name;
  final String image;
  final int price;

  Product(this.id, this.name, this.image, this.price);
}

class Category {
  final String id;
  final String name;
  final String photo;

  Category(this.id, this.name, this.photo);
}


class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class Cart {
  List<CartItem> items = [];

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.product.price * item.quantity);

  void addToCart(Product product) {
    CartItem? cartItem;

    for (var item in items) {
      if (item.product.id == product.id) {
        cartItem = item;
        break;
      }
    }

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      items.add(CartItem(product, 1));
    }
  }

  void removeFromCart(CartItem cartItem) {
    items.remove(cartItem);
  }
}

class Shopping extends StatelessWidget {
  final Cart cart = Cart();

  Future<List<Product>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'affiche',
    });

    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['ID_PROD']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['ID_PROD'], item['NOM_PROD'], item['PHOTO_PROD'], item['PRIX'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';
    var response = await http.post(Uri.parse(url), body: {
      'click': 'CAT',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category(item['ID_CAT'], item['NOM_CAT'],item['PHOTO_CAT'])).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cart: cart, fetchProducts: fetchProducts, fetchCategories: fetchCategories,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Cart cart;
  final Future<List<Product>> Function() fetchProducts;
  final Future<List<Category>> Function() fetchCategories; // Ajoutez cette ligne

  MyHomePage({required this.cart, required this.fetchProducts, required this.fetchCategories}); // Ajoutez fetchCategories ici

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
int _calculateTotalItems(Cart cart) {
  int totalItems = 0;
  for (var cartItem in cart.items) {
    totalItems += cartItem.quantity;
  }
  return totalItems;
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.menu, color: Colors.blueAccent,),
                ),
                Text('Doc\'Shop',style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18
                ),),
                IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.person, color: Colors.blueAccent,),
                ),
              ],
            ),
          ),
          CarouselSlider(
              items: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: NetworkImage('https://emploie.alwaysdata.net/daywatch/image/titan s1.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: NetworkImage('https://emploie.alwaysdata.net/daywatch/image/dragon  ball super.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: NetworkImage('https://emploie.alwaysdata.net/daywatch/image/gardien1.jpg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ],
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height/3,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(
                    seconds: 5
                ),
                autoPlayAnimationDuration: Duration(
                    milliseconds: 800
                ),
              )
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              TextButton(onPressed: () {}, child: Text('Produits classe par categories ->')),
            ],
          ),
          Row(
            children: [
              TextButton(onPressed: () {}, child: Text('Marques locales ->')),
            ],
          ),
          Expanded(child: FutureBuilder<List<Product>>(
            future: widget.fetchProducts(),
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
                    var product = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                            ),
                          );
                        },
                        child: Container(
                          height: 180,
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
                                        builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 120,
                                        width: MediaQuery.of(context).size.width/4,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    product.image
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
          Row(
            children: [
              TextButton(onPressed: () {}, child: Text('Tout les produits ->')),
            ],
          ),
          Expanded(child: FutureBuilder<List<Product>>(
            future: widget.fetchProducts(),
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
                    var product = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                            ),
                          );
                        },
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width/1.2,
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
                                        builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width/2.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                product.image
                                            ),
                                            fit: BoxFit.cover
                                        )
                                    ),
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
          ),)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(cart: widget.cart)),
          );
        },
        label: Text('${_calculateTotalItems(widget.cart)}'), // Utilise la fonction _calculateTotalItems
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}


class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Future<void> placeOrder() async {
    // Liste des ID des produits dans le panier
    List<String> idProduitsStr = widget.cart.items.map((item) => item.product.id.toString()).toList();
    // Liste des quantités correspondantes
    List<String> quantitesStr = widget.cart.items.map((item) => item.quantity.toString()).toList();


    // Prix total du panier
    double prixTotal = widget.cart.totalPrice;

    // Récupérer l'ID de l'utilisateur connecté (vous devez l'obtenir de votre système d'authentification)
    int idUtilisateur = 7; // ID de l'utilisateur connecté

    // Créer les données à envoyer à l'API
    Map<String, dynamic> data = {
      'id_utilisateur': idUtilisateur.toString(),
      'id_produit': idProduitsStr,
      'quantite': quantitesStr,
      'prix_total': prixTotal.toString(),
    };

    // Envoyer la requête POST à l'API pour enregistrer la commande
    var response = await http.post(
      Uri.parse('http://karlmichel.alwaysdata.net/Commander.php'), // Remplacez par l'URL de votre API PHP
      body: data,
    );
    print(response.body);
    // Vérifier la réponse de l'API et afficher un message approprié
    if (response.statusCode == 200) {
      // La commande a été enregistrée avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
    } else {
      // Il y a eu une erreur lors de l'enregistrement de la commande
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement de la commande.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cart.items.length,
                  itemBuilder: (context, index) {
                    var cartItem = widget.cart.items[index];
                    return ListTile(
                      title: Text(cartItem.product.name),
                      subtitle: Text('Quantity: ${cartItem.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (cartItem.quantity > 1) {
                                  cartItem.quantity--;
                                } else {
                                  widget.cart.removeFromCart(cartItem);
                                }
                              });
                            },
                          ),
                          Text('${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                cartItem.quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Récupérer les ID des produits et les quantités depuis le panier
                        List<int> idProduits = widget.cart.items.map((item) => item.product.id).toList();
                        List<int> quantites = widget.cart.items.map((item) => item.quantity).toList();

                        // Convertir les listes en chaînes de caractères séparées par des virgules
                        String idProduitsString = idProduits.join(",");
                        String quantitesString = quantites.join(",");

                        // Prix total depuis le cart
                        double prixTotal = widget.cart.totalPrice;

                        // ID utilisateur (remplacez par votre logique d'authentification)
                        int idUtilisateur = 123; // Exemple d'ID utilisateur

                        // Construire le corps de la requête POST
                        var requestBody = {
                          'id_utilisateur': idUtilisateur.toString(),
                          'id_produits': idProduitsString,
                          'quantites': quantitesString,
                          'prix_total': prixTotal.toString(),
                        };

                        // Envoyer la requête POST à l'API
                        var response = await http.post(Uri.parse('http://karlmichel.alwaysdata.net/Commander.php'), body: requestBody);
                        print(response.body);
                        if (response.statusCode == 200) {
                          // La commande a été enregistrée avec succès
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Commande enregistrée avec succès.'),
                            ),
                          );
                          // Effacer le panier après la commande
                          setState(() {
                            widget.cart.items.clear();
                          });
                        } else {
                          // Erreur lors de l'enregistrement de la commande
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur lors de l\'enregistrement de la commande.'),
                            ),
                          );
                        }
                      },
                      child: Text('Passer la commande'),
                    ),
                  ],
                ),
              ),
            ],
        ),
    );
  }
}