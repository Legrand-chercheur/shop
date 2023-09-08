import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/register.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
              SizedBox(width: 30,),
              Text('Mot de passe oublie')
            ],
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text('Vous pouvez entrer votre email pour recevoir votre code de reinisialisation!',style: TextStyle(
                fontSize: 15
            ),),
          ),
          SizedBox(height: 60,),
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
          GestureDetector(
            onTap: (){
              //Connexion(Student.text, ClasseId.text);
            },
            child: Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text('Envoyer code',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
