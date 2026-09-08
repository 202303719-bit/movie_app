import 'package:dio/dio.dart';

class MovieApiService {
  static const String apiKey = '8d34aff24549adbdbe9baf374d04de19';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  final Dio _dio = Dio();

  Future<List<dynamic>> getPopularMovies() async {
    final response = await _dio.get(
      '$baseUrl/movie/popular',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    if (response.statusCode == 200) {
      return response.data['results'] ?? [];
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

    final response = await _dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'api_key': apiKey,
        'language': 'en-US',
        'page': 1,
      },
    );

    if (response.statusCode == 200) {
      return response.data['results'] ?? [];
    }

    throw Exception('Failed to load movies');
  }

  String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return '';
    }

    return '$imageBaseUrl$posterPath';
  }

  Future<List<dynamic>> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final response = await _dio.get(
      '$baseUrl/search/movie',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'query': query.trim(),
        'page': 1,
      },
    );

    if (response.statusCode == 200) {
      return response.data['results'] ?? [];
    }

    throw Exception('Failed to search movies');
  }

  Future<dynamic> getMovieById(int movieId) async {
    final response = await _dio.get(
      '$baseUrl/movie/$movieId',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    }

    throw Exception('Failed to load movie');
  }
}
