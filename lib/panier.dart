import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_home.dart';

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
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Total',style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38
                  ),),
                  Text(
                    '${widget.cart.totalPrice} Fcfa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
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
                onPressed: () async {
                  // Récupérer les items du panier
                  List<CartItem> cartItems = widget.cart.items;

                  ConvertColor(Color? selectedColor) {
                    final rgb = selectedColor!.red.toString() +
                        '. ' +
                        selectedColor.green.toString() +
                        '. ' +
                        selectedColor.blue.toString();
                    return rgb;
                  }
                  // Récupérer les informations sur les produits, tailles et couleurs depuis le panier
                  List<Product> products = cartItems.map((item) => item.product).toList();
                  List<String?> tailles = cartItems.map((item) => item.size).toList();
                  List<String> couleurs = cartItems.map((item) => ConvertColor(item.color)).toList();
                  List<int> quantites = cartItems.map((item) => item.quantity).toList();

                  // Convertir les listes en chaînes de caractères séparées par des virgules
                  String idProduitsString = products.map((product) => product.id).join(",");
                  String quantitesString = quantites.join(",");
                  String taillesString = tailles.join(",");
                  String couleursString = couleurs.join(",");

                  // Prix total depuis le panier
                  double prixTotal = widget.cart.totalPrice;

                  // ID utilisateur (remplacez par votre logique d'authentification)
                  int idUtilisateur = 1; // Exemple d'ID utilisateur

                  // Construire le corps de la requête POST
                  var requestBody = {
                    'id_utilisateur': idUtilisateur.toString(),
                    'id_produits': idProduitsString,
                    'quantites': quantitesString,
                    'tailles': taillesString, // Ajoutez la taille
                    'couleurs': couleursString, // Ajoutez la couleur
                    'prix_total': prixTotal.toString(),
                  };
                  print(requestBody);
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
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.9,
                  height: 60,
                  child: Center(child: Text('Passer la commande', style: TextStyle(
                      color: Colors.white
                  ),)),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                var cartItem = widget.cart.items[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width/3.5,
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(cartItem.product.cheminImage),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cartItem.product.name,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),),
                            Text('Taille: '+cartItem.size!),
                            Row(
                              children: [
                                Text('Couleur: '),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: cartItem.color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Text('${(int.parse(cartItem.product.price) * cartItem.quantity)} Fcfa',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              color: Colors.blueAccent
                            ),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 15,),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 40,),
                                Row(
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
                                    Text('${(cartItem.quantity)}'),
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
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}