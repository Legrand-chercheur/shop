import 'package:flutter/material.dart';
import 'package:shop/shop.dart'; // Importez votre classe Cart ici

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Cart cart;

  ProductDetailPage({required this.product, required this.cart});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(widget.product.image),
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
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  'Description du produit...',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.cart.addToCart(widget.product);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} ajouté au panier'),
                      ),
                    );
                  },
                  child: Text('Ajouter au panier'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

