 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart 'as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class YouTubeChannelVideos extends StatefulWidget {
  @override
  _YouTubeChannelVideosState createState() => _YouTubeChannelVideosState();
}

class _YouTubeChannelVideosState extends State<YouTubeChannelVideos> {
  final String apiKey = 'AIzaSyAQOrD3aZplM45cMaQDiILmoNIkPoMpT6s';
  final String channelId = 'UCK2ao29rVuXcrpb7_1gv6VQ';
  List<String> videoIds = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet,id&order=date&maxResults=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'];

      List<String> ids = [];
      for (var item in items) {
        if (item['id']['kind'] == 'youtube#video') {
          ids.add(item['id']['videoId']);
        }
      }

      setState(() {
        videoIds = ids;
      });
    } else {
      print('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My YouTube Channel')),
      body: videoIds.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: videoIds.length,
        itemBuilder: (context, index) {
          YoutubePlayerController _controller = YoutubePlayerController(
            initialVideoId: videoIds[index],
            flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
          return Card(
            margin: EdgeInsets.all(8),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          );
        },
      ),
    );
  }
}