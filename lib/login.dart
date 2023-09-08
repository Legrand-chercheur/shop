import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/register.dart';
import 'package:shop/reset_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _Connexion() async {
    final response = await http.post(
      Uri.parse('http://karlmichel.alwaysdata.net/api.php'),
      body: {
        'click': 'con',
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      // Gérer la réponse du backend (connexion réussie ou non)
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["success"]) {
        if (responseData['success'] == true) {
          int userId = responseData['user_id'];
          String pseudo = responseData['pseudo'];
          String email = responseData['email'];
          String telephone = responseData['telephone'];
          final SharedPreferences sauvegarde = await SharedPreferences.getInstance();
          sauvegarde.setInt('userId', userId);
          sauvegarde.setString('userPseudo', pseudo);
          sauvegarde.setString('userEmail', email);
          sauvegarde.setString('userTelephone', telephone);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
        } else {
          // Connexion échouée
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Erreur de connexion'),
                content: Text('Vérifiez vos informations de connexion.'),
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
      } else {
        // Gérer les erreurs de connexion au serveur
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Erreur de connexion au serveur.'),
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
                Text('Conncetez vous')
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text('Bienvenue et',style: TextStyle(
                    fontSize: 30
                  ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text('Bon Retour!',style: TextStyle(
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
                  controller: _emailController,
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
                  controller: _passwordController,
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
            Padding(
              padding: const EdgeInsets.only(left: 250),
              child: Row(
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Reset()));
                    },
                    child: Text('Mot de passe oublie?',style: TextStyle(
                        color: Colors.blueAccent
                    ),),)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/8,),
            GestureDetector(
              onTap: (){
                _Connexion();
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Se connecter',style: TextStyle(
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
                Text('N\'avez vous pas de compte?'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                }, child: Text('S\'inscrire',style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
