import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/signin.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen ({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
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
            Text("Sign up",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox( width: 300,
              child: TextFormField(
                initialValue: '',
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
              child: TextFormField(obscureText: true,
                initialValue: '',
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
                      text: "Already have an account?", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      children: [
                        TextSpan( recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                        },
                          text: " Tap here!", style: TextStyle(color: Colors.cyan)
                      )

                      ]

                  )
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.check, size: 18),
              label: Text("Sign up"),
            )

          ],
        ),
      ),
    );
  }
}

