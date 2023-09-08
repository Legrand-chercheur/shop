import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'otp_verificarion.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController mdp = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController pseudo = TextEditingController();

  String _errorMessage = '';

  Future<void> _signup(BuildContext context) async {
    setState(() {
      _errorMessage = '';
    });

    String emails = email.text;
    String password = mdp.text;

    final response = await http.post(
      Uri.parse('http://karlmichel.alwaysdata.net/api.php'),
      body: {
        'click': 'code_verification',
        'email': emails
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OTP(email: emails, pseudo: pseudo.text, telephone: tel.text, password: password, code: responseData['code'],)),
        );
      } else {
        // Gérer les erreurs d'inscription
        setState(() {
          _errorMessage = responseData['message'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Erreur de\'inscription'),
                content: Text(_errorMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fermer'),
                  ),
                ],
              );
            },
          );
        });
      }
    } else {
      // Gérer les erreurs de connexion au serveur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur d\'inscription'),
            content: Text('Probleme de connexion au serveur'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
                SizedBox(width: 30,),
                Text('Incrivez vous')
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text('Creer votre',style: TextStyle(
                      fontSize: 30
                  ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text('Compte!',style: TextStyle(
                      fontSize: 30
                  ),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 20,top: 4),
                child: TextField(
                  controller: pseudo,
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.person_alt,color: Colors.white,),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: "Pseudo",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),

                    focusColor: Colors.white,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,

                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 20,top: 4),
                child: TextField(
                  controller: tel,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.phone_fill,color: Colors.white,),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: "Telephone",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),

                    focusColor: Colors.white,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,

                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 20,top: 4),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.mail_solid,color: Colors.white,),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),

                    focusColor: Colors.white,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,

                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 20,top: 4),
                child: TextField(
                  controller: mdp,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.lock_fill,color: Colors.white,),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: "Mot de passe",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),

                    focusColor: Colors.white,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,

                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            GestureDetector(
              onTap: (){
                _signup(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('S\'inscrire',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Avez vous deja un compte?'),
                TextButton(onPressed: (){}, child: Text('Se connecter',style: TextStyle(
                    color: Colors.blueAccent
                ),))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    //Connexion(Student.text, ClasseId.text);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2.3,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/logo.png'))
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('Se connecter avec google',style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    //Connexion(Student.text, ClasseId.text);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2.3,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/facebook.png'))
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('Se connecter avec Facebook',style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
