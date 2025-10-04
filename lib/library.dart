import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/util/AuthStorage.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String sortBy="Date, recent";
  List<Map<String, dynamic>> _videos = [];

  Future<List<Map<String, dynamic>>> fetchUserVideos() async {
    final idToken = await AuthStorage.getIdToken();

    final res = await http.get(
      Uri.parse("http://10.0.2.2:5000/user/data"), // same endpoint
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((doc) => doc as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to fetch videos: ${res.body}");
    }
  }
  @override
  void initState() {
    super.initState();
    fetchUserVideos().then((data) {
      setState(() {
        _videos = data;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos"),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox( width: 200,
                  child: TextField(decoration:InputDecoration(
                      labelText: "Video Name",
                      border: OutlineInputBorder()
                  )
                  ),
                ),
                SizedBox(width: 40,),
                DropdownButton(
                    value: sortBy,
                    icon: Icon(Icons.arrow_right),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    items: [
                      DropdownMenuItem(child: Text("Date, recent        "),value: "Date, recent",),
                      DropdownMenuItem(child: Text("Name, a-z           "), value: "Name, a-z" ,),
                      DropdownMenuItem(child: Text("Date, oldest        "), value: "Date, oldest",)
                    ],
                    onChanged: (String? value){
                      setState(() {
                        sortBy=value!;
                      });
                    }
                )
              ],
            ),
          ),
          Expanded(
            child: Container(

              child:
                ListView.builder(
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return VideoTile(
                      name: video["name"] ?? "Unnamed",
                      date: video["createdAt"] ?? "Unknown",
                      duration: video["length"] ?? "N/A",
                    );
                  },
                ),

              ),
            ),

        ],
      ),
    );
  }
}
class VideoTile extends StatelessWidget {
  final String name;
  final String date;
  final String duration;
  const VideoTile({super.key, required this.name, required this.date, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 230,
            color: Colors.red,
          ),
          Center(
            child: Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 27),),
                  Text(date),
                  Text(duration)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
