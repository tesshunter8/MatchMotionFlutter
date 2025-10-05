import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:untitled/util/AuthStorage.dart';
import 'package:untitled/util/Constants.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ImagePicker imagePicker=ImagePicker();
  VideoPlayerController? _controller;
  final _nameController=TextEditingController();
  bool _isPlaying=false;
  bool _isEnded=false;
  // small tolerance to detect "end" (accounts for small timing differences)
  static const Duration _endTolerance = Duration(milliseconds: 200);


  late XFile video;
  void ChooseVideo()async{
    final XFile? pickedvideo=await imagePicker.pickVideo(source: ImageSource.gallery);
    if(pickedvideo!=null){
        video=pickedvideo;
        _controller = VideoPlayerController.file(File(video.path));
        await _controller!.initialize();

        // add listener
        _controller!.addListener(_videoListener);

        // reset UI flags
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
          _isEnded = false;
        });


    }

  }
  void _videoListener() {
    if (!mounted || _controller == null) return;
    final value = _controller!.value;

    // Always rebuild so slider/time update
    setState(() {
      _isPlaying = value.isPlaying;

      final dur = value.duration;
      final pos = value.position;
      if (dur != null && pos != null) {
        final isEnd = pos >= dur - _endTolerance;
        if (isEnd && !value.isPlaying) {
          _isEnded = true;
          _isPlaying = false;
        } else {
          _isEnded = false;
        }
      }
    });
  }
  Future<void> _disposeController() async {
    if (_controller != null) {
      try {
        _controller!.removeListener(_videoListener);
      } catch (_) {}
      try {
        await _controller!.pause();
      } catch (_) {}
      try {
        await _controller!.dispose();
      } catch (_) {}
      _controller = null;
    }
  }
  Future<void>sendvideotoserver()async{
    var uri = Uri.parse("${Constants.BaseUrl}/upload"); // use 10.0.2.2 for Android emulator, or localhost for web

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
      Uri.parse("${Constants.BaseUrl}/user/data"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken"
      },
      body: jsonEncode(
          {
            "name": videoname,
            "createdAt":DateTime.now().toUtc().toIso8601String(),
            "length": 0
          }
      ),
    );
    print(res.body);
  }
  Future<void> _playPause() async {
    if (_controller == null) return;
    final value = _controller!.value;

    if (value.isPlaying) {
      await _controller!.pause();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      // if video was ended, seek to start first (await to avoid race)
      if (_isEnded) {
        await _controller!.seekTo(Duration.zero);
        _isEnded = false;
      }
      await _controller!.play();
      if (mounted) setState(() => _isPlaying = true);
    }
  }
  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  @override
  void dispose() {
    _disposeController();
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bool hasController =
        _controller != null && _controller!.value.isInitialized;
    final double maxMs = hasController
        ? _controller!.value.duration.inMilliseconds.toDouble()
        : 1.0;
    final double positionMs = hasController
        ? _controller!.value.position.inMilliseconds.toDouble().clamp(0.0, maxMs)
        : 0.0;
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
            // Video preview
            Container(
              width: 300,
              height: 200,
              color: Colors.grey,
              child: hasController
                  ? VideoPlayer(_controller!)
                  : const Center(child: Text("No video selected")),
            ),
            const SizedBox(height: 20),

// Controls
            if (hasController) ...[
              Row(
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () => _playPause(),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: maxMs,
                      value: positionMs,
                      onChanged: (value) {
                        _controller!
                            .seekTo(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(_controller!.value.position)),
                    Text(formatDuration(_controller!.value.duration)),
                  ],
                ),
              ),
            ],
            SizedBox( height: 30,),
            SizedBox( width: 300,
             child: TextField(decoration:InputDecoration(
               labelText: "Video Name",
               border: OutlineInputBorder()
             )
             ),
             ),
            SizedBox(height: 40,),
            (_controller==null)?Container():
            ElevatedButton(onPressed: (){
              sendvideotoserver();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your video is now processing..."),duration: Duration(seconds: 10),));
            }, child: Text("Analyze Video"))],
        ),
      ),
    );
  }
}
