import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:untitled/util/AuthStorage.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ImagePicker imagePicker=ImagePicker();
  final String baseUrl="http://10.0.2.2:5000";
  late XFile video;
  void ChooseVideo()async{
    final XFile? image=await imagePicker.pickVideo(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        video=image;
      });

    }

  }
  Future<void>sendvideotoserver()async{
    var uri = Uri.parse("http://10.0.2.2:5000/upload"); // use 10.0.2.2 for Android emulator, or localhost for web

    final mimeTypeData = lookupMimeType(video.path)?.split('/') ?? ['image', 'jpeg'];

    final request = http.MultipartRequest("POST", uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file', // name must match the Flask form field
          video.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Image uploaded successfully");
        // You can read the response body if needed:
        final body = await response.stream.bytesToString();
        print("Response body: $body");
        storeindatabase("test");
      } else {
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }
  Future<void>storeindatabase(String videoname)async{
    final idToken=await AuthStorage.getIdToken();
    final res = await http.post(
      Uri.parse("$baseUrl/user/data"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: jsonEncode(
          {
            "name": videoname,
            "createdApp":DateTime.now().toUtc().toIso8601String()
          }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload New Video"),),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            ElevatedButton(onPressed: (){
              ChooseVideo();
            }, child: Text("Upload File")),
            SizedBox(height: 50,),
            Container(color: Colors.grey, width: 300,height: 200,),
            SizedBox( height: 30,),
            SizedBox( width: 300,
             child: TextField(decoration:InputDecoration(
               labelText: "Video Name",
               border: OutlineInputBorder()
             )
             ),
             ),
            SizedBox(height: 40,),
            ElevatedButton(onPressed: (){
              sendvideotoserver();
            }, child: Text("Analyze Video"))],
        ),
      ),
    );
  }
}
