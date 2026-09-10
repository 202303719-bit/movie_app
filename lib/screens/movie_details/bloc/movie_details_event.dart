import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the screen opens (or on retry) to load
/// both the movie details and its suggestions.
class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const FetchMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

/// Optional: pull-to-refresh support.
class RefreshMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const RefreshMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
