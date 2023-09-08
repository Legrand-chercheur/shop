import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_home.dart';

class OTP extends StatefulWidget {
  var email, pseudo, telephone, password, code;
  OTP({required this.email, required this.pseudo, required this.telephone, required this.password, required this.code});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  String _errorMessage = '';
  String code = '';
  int IntCode = 0;
  Future<void> _signup(BuildContext context) async {
    setState(() {
      _errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('http://karlmichel.alwaysdata.net/api.php'),
      body: {
        'click': 'ins',
        'email': widget.email,
        'password': widget.password,
        'pseudo': widget.pseudo,
        'telephone': widget.telephone,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success']) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context)=>Boutique()),
                (route) => false
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
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)
                ),
                SizedBox(width: 30,),
                Text('Code de verification')
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text('Entrer le code de verification que vous avez recu par mail! $code',style: TextStyle(
                  fontSize: 14
              ),),
            ),
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code1){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code2){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code3){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onSaved: (code4){},
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                            code = code + value;
                            IntCode = int.parse(code);
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(counterText: "",border: InputBorder.none),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 65),
              child: Row(
                children: [
                  Text('Vous n\'avez pas recu de code?'),
                  TextButton(
                    onPressed: (){
                      code = "";
                      IntCode = 0;
                    },
                    child: Text('Renvoyer le code',style: TextStyle(
                        color: Colors.blueAccent
                    ),),)
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/6,),
            GestureDetector(
              onTap: (){
                if(IntCode == widget.code){
                  _signup(context);
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('confirmation'),
                        content: Text('Le code ne correspond pas, Reesayer...'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              code = "";
                              IntCode = 0;
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Confirmer',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
