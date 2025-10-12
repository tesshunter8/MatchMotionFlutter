import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Future<Map<String, dynamic>> FetchVideoData() async {
    //make HTTP request to server
    final data={
      "name": "badminton game",
      "createdAt": "2025-10-05T01:25:53.094592Z",
      "length": 100,
      "userId": "6RBqTJcNkvNQV138VIhRu4giZSC2",
      "stats": {
        "averageRallyLength": 10,
        "longestRallyLength": 10,
        "frontPlayer": {},
        "backPlayer": {},
        
      }
    };
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FetchVideoData(),
      builder: (context, asyncSnapshot) {
        final data=asyncSnapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(data?["name"]),
          ),
          body: Column(
            children: [
              Text(data!["stats"]["longestRallyLength"].toString())
            ],
          ),
        );
      }
    );
  }
}
