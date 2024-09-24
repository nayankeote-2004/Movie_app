import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie['name'] ?? 'Unknown Title'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    top: MediaQuery.of(context).padding.top, // Add padding to top
                    child: movie['image'] != null
                        ? Image.network(
                            movie['image']['original'] ?? 'https://via.placeholder.com/500x750',
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey[800]),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.play_arrow),
                        label: Text('Play'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.download),
                        label: Text('Download'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _stripHtmlTags(movie['summary'] ?? 'No summary available'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Genre: ${(movie['genres'] as List?)?.join(', ') ?? 'Not available'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: ${movie['status'] ?? 'Not available'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  if (movie['rating'] != null && movie['rating']['average'] != null)
                    Text(
                      'Rating: ${movie['rating']['average']}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _stripHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}