import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_details.dart';
import 'new_home.dart';

class CategoryProductsPage extends StatelessWidget {
  final Category category;
  final Cart cart;

  CategoryProductsPage({required this.category, required this.cart});


  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';
    var response = await http.post(Uri.parse(url), body: {
      'click': 'Prod_category',
      'id_category': categoryId,
    });
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(item['prod_id'], item['nom_prod'], item['chemin_image'], item['prix'])).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProductsByCategory(category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productDetailPage(product: product, cart: cart),
                      ),
                    );
                  },
                  title: Text(product.name),
                  subtitle: Text('\$${int.parse(product.price).toStringAsFixed(2)}'),
                  leading: Image.network(product.cheminImage),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      cart.addToCart(product,'XL',Color.fromARGB(255, 255, 255, 240), 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


