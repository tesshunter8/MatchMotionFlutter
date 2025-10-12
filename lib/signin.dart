import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/createaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/test.dart';
import 'package:untitled/util/AuthStorage.dart';
import 'package:untitled/util/Constants.dart';

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

  String? IdToken;
  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("${Constants.BaseUrl}/auth/login"),
      headers: {
        "Content-Type": "application/json", 'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({"email": email, "password": password}),
    ).timeout(
      Duration(seconds: 15),
      onTimeout: (){
        throw TimeoutException("15 seconds have passed");
      }
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        IdToken = data["idToken"];
        print("Login success: token stored.");

      });
      await AuthStorage.saveTokens(data["idToken"],data["refreshToken"]);
      return true;
    } else {
      print("Login failed: ${res.body}");
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
                           login(emailcontroller.text, passwordcontroller.text).then((bool returnedValue){
                            if (returnedValue==true){
                              print ("Log in successful");
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
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

