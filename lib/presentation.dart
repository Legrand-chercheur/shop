import 'package:flutter/material.dart';
import 'package:shop/login.dart';
import 'package:shop/register.dart';

class Presentation extends StatefulWidget {
  const Presentation({super.key});

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Positioned(
              left: 20,
              bottom: 10,
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/2.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bienvenue a Doc\'shop',style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Venez commander vos t-shirt, tasse, carte de visite, banderole dans notre imprimerie via l\'application Doc\'Shop',style: TextStyle(
                          color: Colors.black54,
                        ),),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.6,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(child: Text('Inscription',style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),))
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width/2.6,
                                  height: 60,
                                  child: Center(child: Text('Connexion',style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),))
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
          ),
        ],
      ),
    );
  }
}
