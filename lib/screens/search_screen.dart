import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      searchMovies(_searchController.text);
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<void> searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: TextStyle(fontSize: 28,color: Colors.red)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Search for a show',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? Center(child: Text('Start typing to search for shows!'))
                : searchResults.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final movie = searchResults[index]['show'];
                          return ListTile(
                            leading: movie['image'] != null
                                ? Image.network(movie['image']['medium'] ?? 'https://via.placeholder.com/50x75')
                                : Container(
                                    width: 50,
                                    height: 75,
                                    color: Colors.grey[800],
                                    child: Icon(Icons.movie, color: Colors.white),
                                  ),
                            title: Text(movie['name'] ?? 'Unknown Title', style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                              (movie['genres'] as List<dynamic>?)?.join(', ') ?? 'No genres available',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: movie,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}