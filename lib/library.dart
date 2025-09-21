import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String sortBy="Date, recent";
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

              child: ListView(
                children: [
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                  VideoTile(name: "Test", date: "2025/9/6", duration: "2 mins 2 secs"),
                ],
              ),
            ),
          )
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
