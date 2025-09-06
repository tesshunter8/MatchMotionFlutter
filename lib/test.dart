
import 'package:flutter/material.dart';
import 'package:untitled/signin.dart';
import 'package:untitled/video.dart';

import 'circleimage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title});



  final String title;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
    print(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff2f46cc),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
            },
            child: Text("press")
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Hello"),
        ),
        body: ListView(
          children: [
            CircleImage(imageurl: 'https://cdn.britannica.com/44/256944-050-8D414329/PV-Sindhu-2020-Tokyo-Olympics.jpg',),
            CircleImage(imageurl: 'https://cdn.britannica.com/44/256944-050-8D414329/PV-Sindhu-2020-Tokyo-Olympics.jpg',),
            Text (_counter.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network (
                  "https://hudsonreporter.com/wp-content/uploads/2024/12/Everything-You-Need-To-Know-About-Badminton_FI.jpg",
                  width:200 ,
                ),
                Image.network (
                  "https://www.paralympic.org/sites/default/files/styles/large_original/public/2019-09/Lima-2019-day-9-badminton.jpg?itok=IrvroxF-",
                  width: 200,
                )
              ],
            )
          ],
        )
    );
  }
}
