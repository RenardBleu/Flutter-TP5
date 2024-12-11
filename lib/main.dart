import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'show-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OMDb API Demo',
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OMDb Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Movies'),
              onSubmitted: (value) {
                _searchMovies(value);
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => MovieShowScreen(id: _movies[index])));
                    },
                    title: Text(_movies[index].title),
                    subtitle: Text(_movies[index].years),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _searchMovies(String query) async {
    const apiKey = 'f77d6379';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&s=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> movies = data['Search'];

      setState(() {
        _movies = movies.map((movie) => Movie.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class MovieShowScreen extends StatefulWidget {

  const MovieShowScreen({super.key, required this.id});
  final String id;

  

  @override
  _MovieShowScreenState createState() => _MovieShowScreenState();
}

class _MovieShowScreenState extends State<MovieShowScreen> {

List<Movie> _movies = [];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.movie.title ?? 'Details du film'),
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator())
      : _movieDetails == null
      ? Center(child: Text('Erreur de chargement'))
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre: ${_movieDetails!['Title']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 10),
                Text(
                  'Année: ${_movieDetails!['Year']}'),
            ],
          ),
        ),
    );
  }

  Future<void>_initState(String query) async {
    const apiKey = 'f77d6379';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> movies = data['Search'];

      setState(() {
        _movies = movies.map((movie) => Movie.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

}

class Movie{
  final String title;
  final String years;
  final String id;

  Movie({required this.title , required this.years});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'Pas de titre',
      years: json['Year'] ?? 'pas d\'année',
    );
  }
}