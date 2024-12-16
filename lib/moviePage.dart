import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


//----- SHOW FILM PAGE -----



class MovieShowScreen extends StatefulWidget {

  MovieShowScreen({super.key, required this.id, required this.title});
  final String id;
  final String title;
  

  @override
  _MovieShowScreenState createState() => _MovieShowScreenState();
}

class _MovieShowScreenState extends State<MovieShowScreen> {
Map<String, dynamic>? _movieDetails;
bool _isLoading = true;


@override
Widget build(BuildContext context) {
  _showFilm(widget.id);
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title ?? 'Details du film'),
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _movieDetails == null
      ? const Center(child: Text('Erreur de chargement'))
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre: ${_movieDetails!['Title']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 10),
                Text(
                  'Année: ${_movieDetails!['Year']}'),
            ],
          ),
        ),
    );
  }


//----- FONCTION SHOW FILM PAGE -----



  Future<void>_showFilm(String query) async {
    const apiKey = 'f77d6379';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _movieDetails = json.decode(response.body);
      });
    } else {
      _isLoading = false;
      throw Exception('Failed to load movies');
    }
  }

}

//----- OBJET FILM -----


class Movie{
  final String title;
  final String years;
  final String imdbID;

  Movie({required this.title , required this.years, required this.imdbID});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'Pas de titre',
      years: json['Year'] ?? 'pas d\'année',
      imdbID: json['imdbID'] ?? 'aucun id'
    );
  }
}