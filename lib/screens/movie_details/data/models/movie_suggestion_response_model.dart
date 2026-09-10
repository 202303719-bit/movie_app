import 'movie_data_model.dart';

class MovieSuggestionsResponseModel {
  final String status;
  final String statusMessage;
  final MoviesData data;

  MovieSuggestionsResponseModel({
    required this.status,
    required this.statusMessage,
    required this.data,
  });

  factory MovieSuggestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionsResponseModel(
      status: json['status'] ?? '',
      statusMessage: json['status_message'] ?? '',
      data: MoviesData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_message': statusMessage,
      'data': data.toJson(),
    };
  }
}

class MoviesData {
  final int movieCount;
  final List<Movie> movies;

  MoviesData({
    required this.movieCount,
    required this.movies,
  });

  factory MoviesData.fromJson(Map<String, dynamic> json) {
    return MoviesData(
      movieCount: json['movie_count'] ?? 0,
      movies: (json['movies'] as List? ?? [])
          .map((e) => Movie.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_count': movieCount,
      'movies': movies.map((e) => e.toJson()).toList(),
    };
  }
}

