import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'new_home.dart';

class MyCustomTransitions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.push(context, SizeTransition5(SecondPage())),
              child: Text('TAP TO VIEW SIZE ANIMATION 5')),
        ],
      ),
    );
  }
}

class SizeTransition5 extends PageRouteBuilder {
  final Widget page;

  SizeTransition5(this.page)
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: Duration(milliseconds: 1000),
    reverseTransitionDuration: Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          parent: animation,
          reverseCurve: Curves.fastOutSlowIn);
      return Align(
        alignment: Alignment.centerRight,
        child: SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: animation,
          child: page,
          axisAlignment: 0,
        ),
      );
    },
  );
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? name;
  Future<List<Product>> fetchProducts(String? searchTerm) async {
    var url = 'http://karlmichel.alwaysdata.net/affiche.php';

    var response = await http.post(Uri.parse(url), body: {
      'click': 'tout',
      'searchTerm': searchTerm ?? '',
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List? listes;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.multiply, color: Colors.black54,),
              ),
              SizedBox(width: 10,),
              Text('Recherche',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              )
            ],
          ),
          SizedBox(height: 20,),

          Container(
            width: 400,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20, top: 4),
              child: TextField(
                decoration: InputDecoration(
                  icon: IconButton(
                    icon: Icon(CupertinoIcons.search, color: Colors.white,),
                    onPressed: () {
                      // Naviguez vers la page de recherche avec le terme actuel
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(searchTerm: name)));
                    },
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  hintText: "Recherchez votre produit...",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),

                  focusColor: Colors.white,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,

                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
                future: fetchProducts(name),
                builder: (context, snapshot) {
                  listes = snapshot.data;
                  if (listes != null) {
                    return ListView.builder(
                        itemCount: listes!.length,
                        itemBuilder: (context, element) {
                          Product product = listes![element];
                          return ListTile(
                            title: GestureDetector(
                              onTap: () {
                                // Naviguez vers la page du produit ou effectuez l'action souhaitée
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(product.cheminImage),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Column(
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        product.price+' Fcfa',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            selected: true,
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator(
                        color: Colors.blueAccent));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
