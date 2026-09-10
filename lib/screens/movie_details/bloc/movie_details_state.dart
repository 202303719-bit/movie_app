import 'package:equatable/equatable.dart';
import 'package:m/screens/movie_details/data/models/movie_data_model.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetailsModel movie;
  final List<Movie> suggestions;

  const MovieDetailsLoaded({
    required this.movie,
    required this.suggestions,
  });

  @override
  List<Object?> get props => [movie, suggestions];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
