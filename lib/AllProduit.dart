import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_details.dart';
import 'new_home.dart';

class ToutProduits extends StatefulWidget {
  final Cart cart;
  const ToutProduits({required this.cart});

  @override
  State<ToutProduits> createState() => _ToutProduitsState();
}

class _ToutProduitsState extends State<ToutProduits> {

  Future<List<Product>> fetchProducts() async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'tout',
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body)[0]['prix']);
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['prod_id'], item['nom_prod'], item['chemin_image'], item['prix'])).toList();
    } else {
      throw Exception('Failed to load products');
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
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                ),
                Text('Tout les produits'),
                IconButton(onPressed: (){}, icon: Icon(Icons.search)),
              ],
            ),
          ),
          Expanded(child: FutureBuilder<List<Product>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Aucun produit n\'a ete commandé.'),);
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var product = snapshot.data![index];
                    print(product);
                    return GestureDetector(
                      onTap: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 380,
                        width: 200,
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
                                      builder: (context) => productDetailPage(product: product, cart: widget.cart),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width/2.5,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Text(product.price+' Fcfa',style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                    ),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),),
        ],
      ),
    );
  }
}
