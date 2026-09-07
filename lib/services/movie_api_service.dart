import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  static const String apiKey = '8d34aff24549adbdbe9baf374d04de19';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<dynamic>> getPopularMovies() async {
    final url = Uri.parse(
      '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    }

    throw Exception('Failed to load popular movies');
  }

  Future<List<dynamic>> getMoviesByCategory(String category) async {
    String genreId;

    switch (category.toLowerCase()) {
      case 'action':
        genreId = '28';
        break;
      case 'adventure':
        genreId = '12';
        break;
      case 'animation':
        genreId = '16';
        break;
      case 'comedy':
        genreId = '35';
        break;
      case 'drama':
        genreId = '18';
        break;
      case 'horror':
        genreId = '27';
        break;
      case 'science fiction':
      case 'sci-fi':
        genreId = '878';
        break;
      default:
        return getPopularMovies();
    }

    final url = Uri.parse(
      '$baseUrl/discover/movie?with_genres=$genreId&api_key=$apiKey&language=en-US&page=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    }

    throw Exception('Failed to load movies');
  }

  String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return '';
    }

    return '$imageBaseUrl$posterPath';
  }Future<List<dynamic>> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final url = Uri.parse(
      '$baseUrl/search/movie'
          '?api_key=$apiKey'
          '&language=en-US'
          '&query=${Uri.encodeQueryComponent(query.trim())}'
          '&page=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    }

    throw Exception('Failed to search movies');
  }

  Future<dynamic> getMovieById(int movieId) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId'
          '?api_key=$apiKey'
          '&language=en-US',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load movie');
  }
}