import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled/util/AuthStorage.dart';
import 'package:untitled/util/Constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String sortBy="Date, recent";
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _filteredvideos = [];
  final NameController=TextEditingController();
  Future<List<Map<String, dynamic>>> fetchUserVideos() async {
    final idToken = await AuthStorage.getIdToken();

    final res = await http.get(
      Uri.parse("${Constants.BaseUrl}/user/data"), // same endpoint
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
  void filtervideos(String name){
    setState(() {
      _filteredvideos=_videos.where((video)=>video["name"].toString().startsWith(name)).toList();
      if (sortBy=="Date, recent"){
        _filteredvideos.sort((a,b){
          final VideoDateA=DateTime.parse(a["createdAt"]);
          final VideoDateB=DateTime.parse(b["createdAt"]);
          return VideoDateB.compareTo(VideoDateA);
        });
      }
      else if (sortBy=="Date, oldest"){
        _filteredvideos.sort((a,b){
          final VideoDateA=DateTime.parse(a["createdAt"]);
          final VideoDateB=DateTime.parse(b["createdAt"]);
          return VideoDateA.compareTo(VideoDateB);
        });
      }
      else if (sortBy=="Name, a-z"){
        _filteredvideos.sort((a,b)=>a["name"].compareTo(b["name"]));
      }
    });

  }
  @override
  void initState() {
    super.initState();
    fetchUserVideos().then((data) {
      setState(() {
        _videos = data;
        _filteredvideos=_videos;
        print(_videos);
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
                  child: TextField(
                      controller: NameController,
                      onChanged: (Name)=>filtervideos(Name),
                      decoration:InputDecoration(
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
                        filtervideos(NameController.text);
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
                  itemCount: _filteredvideos.length,
                  itemBuilder: (context, index) {
                    final video = _filteredvideos[index];
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
  final int duration;
  const VideoTile({super.key, required this.name, required this.date, required this.duration});
  String readableDate(String date) {
    final dt = DateTime.parse(date).toLocal(); // convert from UTC to local time
    final formatter = DateFormat('MMM d, yyyy • h:mm a'); // e.g. Oct 4, 2025 • 7:37 PM
    return formatter.format(dt);
  }
  String formatDuration(int seconds){
    int mins=(seconds/60).toInt();
    int sec=(seconds-mins*60);
    if (sec<=9){
      return "$mins:0$sec";
    } else {
      return "$mins:$sec";
    }
  }
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
                  Text(readableDate(date)),
                  Text(formatDuration(duration))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
