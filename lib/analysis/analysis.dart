import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key, required this.VideoData });
  final Map<String, dynamic>VideoData;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {

  @override
  Widget build(BuildContext context) {



        return Scaffold(
          appBar: AppBar(
            title: Text(widget.VideoData["name"]),
          ),
          body: Column(
            children: [
              Text(widget.VideoData["rally_length"].toString())
            ],
          ),


    );
  }
}
