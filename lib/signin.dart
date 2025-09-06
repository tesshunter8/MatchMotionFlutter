import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/createaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/test.dart';

import 'home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> Formkey=GlobalKey<FormState>();
  final TextEditingController emailcontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();

  Future<bool> signIn(String email, String password) async {
    try {
      print ("Attempting to log in...");
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: Formkey,
              child: Column(
                  children: [
                      Text(
                        "Welcome to",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text("Matchmotion!",
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text("Log in",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox( width: 300,
                        child: TextFormField(controller: emailcontroller,
                          validator: (String? value){
                            if (value==null||value.isEmpty){
                              return "You need to type something";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            //errorText: 'Error message',
                            border: OutlineInputBorder(),
                            //suffixIcon: Icon(
                              //Icons.error,
                            //),

                          ),
                        ),
                      ),
                      SizedBox(height: 35,),

                      SizedBox( width: 300,
                        child: TextFormField(controller: passwordcontroller,
                          validator: (String? value){
                            if (value==null||value.isEmpty){
                              return "You need to type something";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            //errorText: 'Error message',
                            border: OutlineInputBorder(),
                            //suffixIcon: Icon(
                            //Icons.error,
                            //),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                            text: TextSpan(
                                text: "Don't have an account?", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap=(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccountScreen()));
                              },
                                text: " Tap here!", style: TextStyle(color: Colors.cyan)
                              )

                              ]

                          )
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (Formkey.currentState!.validate()){
                           signIn(emailcontroller.text, passwordcontroller.text).then((bool returnedValue){
                            if (returnedValue==true){
                              print ("Log in successful");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                            }
                           });
                          }
                        },
                        icon: Icon(Icons.check, size: 18),
                        label: Text("Log in"),
                      )

                    ],
                  )
            )
          ],
        ),
      ),
    );
  }
}

