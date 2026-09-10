import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:m/screens/movie_details/data/models/movie_suggestion_response_model.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/movie_data_model.dart';

class MovieDetailsRepo {
  final Dio _dio = Dio();


  /// Movie Details and Suggestions
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      var response = await _dio.get(
        '${AppConstants.baseUrl}/movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true
        },
      );
      var data = MovieDetailsModel.fromJson(response.data);
      debugPrint("movie details data : ${response.data}");
      return data;
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<MovieSuggestionsResponseModel> getMovieSuggestions(int movieId) async {
    try {
      var response = await _dio.get(
        '${AppConstants.baseUrl}/movie_suggestions.json',
        queryParameters: {
          'movie_id': movieId,
        },
      );
      var data = MovieSuggestionsResponseModel.fromJson(response.data);
      debugPrint("movie suggestions data : ${response.data}");
      return data;
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

}