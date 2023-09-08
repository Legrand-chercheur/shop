import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/panier.dart';
import 'new_home.dart'; // Importez votre classe Cart ici
import 'package:http/http.dart' as http;

class ProductDetails {
  final String id;
  final String name;
  final String description;
  final String price;
  final String categoryName;
  final List<String> images;

  ProductDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryName,
    required this.images,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    List<String> imageList = List<String>.from(json['images']);

    return ProductDetails(
      id: json['prod_id'],
      name: json['nom_prod'],
      description: json['description'],
      price: json['prix'],
      categoryName: json['nom_cat'],
      images: imageList,
    );
  }
}

class productDetailPage extends StatefulWidget {
  final Product product;
  final Cart cart;

  productDetailPage({required this.product, required this.cart});

  @override
  _productDetailPageState createState() => _productDetailPageState();
}

class _productDetailPageState extends State<productDetailPage> {
  late Future<ProductDetails> _productDetailsFuture;

  @override
  void initState() {
    super.initState();
    _productDetailsFuture = fetchProductDetails(widget.product.id);
    fetchColors();
    fetchTailles();
  }

  List<String> couleurs = [];

  Future<ProductDetails> fetchProductDetails(String productId) async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'details_produits',
      'prod_id': productId,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      return ProductDetails.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<void> fetchColors() async {
    final url = Uri.parse('http://karlmichel.alwaysdata.net/affiche.php'); // Remplacez par l'URL de votre script PHP
    final response = await http.post(url, body: {
      'click': 'couleurs',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> colorStrings = data.map((item) => item.toString()).toList();

      setState(() {
        print(response.body);
        couleurs = colorStrings;
      });
    }
  }


  String? name;
  List<String> tailles = [];
  String? selectedValue;

  Future<void> fetchTailles() async {
    final uri = Uri.parse('http://karlmichel.alwaysdata.net/affiche.php');
    final response = await http.post(uri, body: {
      'click': 'tailles',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(response.body);
      final List<String> sizes = data.map((item) => item.toString()).toList();

      setState(() {
        tailles = sizes;
      });
    }
  }

  int quantite = 1;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Définit la couleur de fond à noir
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Supprime les bordures
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if(quantite<=1){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('minimun atteint'),
                        ),
                      );
                    }else{
                      quantite --;
                    }
                  });
                },
                child: Container(
                  width: 10,
                  height: 60,
                  child: Center(child: Text('-', style: TextStyle(
                      color: Colors.white
                  ),)),
                ),
              ),
              SizedBox(width: 5,),
              Text('$quantite',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(width: 5,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Définit la couleur de fond à noir
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Supprime les bordures
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    quantite ++;
                  });
                },
                child: Container(
                  width: 10,
                  height: 60,
                  child: Center(child: Text('+', style: TextStyle(
                      color: Colors.white
                  ),)),
                ),
              ),
              SizedBox(width: 15,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Définit la couleur de fond à noir
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Supprime les bordures
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.cart.addToCart(widget.product, selectedValue!, selectedColor!,quantite );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.product.name} ajouté au panier'),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.9,
                  height: 60,
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Ajouter au panier', style: TextStyle(
                        color: Colors.white
                      ),),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.cart_fill),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(cart: widget.cart,)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ProductDetails>(
          future: _productDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Erreur de chargement des détails du produit'));
            } else {
              final productDetails = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Afficher les images du produit
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 420,
                        child: PageView.builder(
                          itemCount: productDetails.images.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage('http://karlmichel.alwaysdata.net/'+productDetails.images[index]),
                                    fit: BoxFit.fill
                                )
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${int.parse(widget.product.price).toStringAsFixed(2)} Fcfa',
                            style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 20),
                          Text(
                            productDetails.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          // Afficher les tailles et couleurs disponibles
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Choisir taille',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: tailles.map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )).toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width/2.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.blueAccent,
                              )
                            ),
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: ListView.builder(
                              itemCount: couleurs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final colorString = couleurs[index];
                                final colorValues =
                                colorString.split('.').map((value) => int.parse(value)).toList();
                                final color =
                                Color.fromARGB(255, colorValues[0], colorValues[1], colorValues[2]);

                                final isSelected = color == selectedColor;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = isSelected ? null : color;
                                      if (selectedColor != null) {
                                        final rgb = selectedColor!.red.toString() +
                                            '. ' +
                                            selectedColor!.green.toString() +
                                            '. ' +
                                            selectedColor!.blue.toString();
                                        print('Couleur sélectionnée en RGB : $rgb');
                                      } else {
                                        print('Aucune couleur sélectionnée');
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected ? Colors.blue : Colors.transparent,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

